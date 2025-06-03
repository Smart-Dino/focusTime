//
//  FreeplanUpgradeViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 16.05.2025.
//

import Foundation

/// ViewModel, responsible for managing the logic on ``FreePlanUpgradeView``.
/// - Note: Use it in the ``FreePlanUpgradeView``.
@MainActor
@Observable
final class FreePlanUpgradeViewModel {
    // MARK: - Nested declarations
    struct State {
        var error: Error?
        
        var trialProduct: FTProduct
        var purchaseResult: FTProduct.PurchaseResult?
        
        // Button state
        var isButtonDisabled = true
        
        // Dynamic strings
        static let stringConstants = FreePlanUpgradeView.Constants.Strings.self
        var purchaseButtonTitle    = stringConstants.tryButtonTitle
        var trialPeriodDescription = stringConstants.loadingMessage
    }
    
    // MARK: - Properties
    private(set) var state: State
    private var subscriptionTask: Task<Void, Never>?
    
    // Made this property private becase it is injected
    // through the initializer, not a property.
    private let paymentManager: PaymentManager
    
    // MARK: - Initializers
    init(
        state: State,
        paymentManager: PaymentManager
    ) {
        self.state = state
        self.paymentManager = paymentManager
    }
    
    // A deinitializer is called immediately before a class instance is deallocated
    // - so we should have access to self.state before it deinits?
    deinit {
        Task { [weak self] in
            await self?.subscriptionTask?.cancel()
        }
    }
    
    // MARK: - Methods
    
    // MARK: State setter methods
    func updateError(showError: Bool) {
        if !showError {
            state.error = nil
        }
    }
    
    // MARK: Setup
    func startListeningToSubscriptionUpdates() {
        subscriptionTask?.cancel()
        
        subscriptionTask = Task { [weak self] in
            guard let self else { return }
            for await update in await self.paymentManager.updatesStream() {
                if update == .internalUpdate {
                    self.updatePurchaseResult()
                }
            }
        }
    }
    
    func setupProductInfo() {
        let trialProduct = state.trialProduct
        guard trialProduct.trialPeriod != nil else {
            let error = FreePlanUpgradeError.invalidProduct
            state.error = error
            state.trialPeriodDescription = error.localizedDescription
            // Dismiss view?
            return
        }
        
        if let description = trialProduct.trialPeriodDescription {
            state.trialPeriodDescription = description
        }
        updatePurchaseResult()
    }
    
    private func updatePurchaseResult() {
        Task { [weak self] in
            guard let self else { return }

            let isPurchased = await paymentManager.isPurchased(state.trialProduct)
            state.purchaseResult = isPurchased ? .success : nil
            
            self.updateUIBasedOnPurchaseResult()
        }
    }
    
    private func updateUIBasedOnPurchaseResult() {
        guard let result = state.purchaseResult else {
            // Reset to default if result is nil
            state.purchaseButtonTitle = State.stringConstants.tryButtonTitle
            state.isButtonDisabled = false
            return
        }

        switch result {
        case .success:
            state.purchaseButtonTitle = State.stringConstants.subscribedMessage
            state.isButtonDisabled = true
            state.error = nil

        case .pending:
            state.purchaseButtonTitle = State.stringConstants.pendingMessage
            state.isButtonDisabled = true
            state.error = PaymentError.pending

        case .userCancelled:
            state.purchaseButtonTitle = State.stringConstants.tryButtonTitle
            state.isButtonDisabled = false
            state.error = PaymentError.userCancelled
        }
    }
    
    // MARK: Actions
    func subscribeToFreeTrial() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let result = try await paymentManager.purchase(state.trialProduct)
                
                switch result {
                case .success:
                    state.purchaseResult = .success
                case .userCancelled:
                    state.purchaseResult = .userCancelled
                case .pending:
                    state.purchaseResult = .pending
                case nil:
                    state.error = PaymentError.unknown
                }
                
                updateUIBasedOnPurchaseResult()
            } catch {
                state.error = error
            }
        }
    }
    
    func restorePurchase() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.paymentManager.restorePurchases()
            } catch {
                state.error = error
            }
        }
    }
    
    // MARK: Navigation
    func viewAllPlans() {
        // Show all plans
    }
    
    func openTermsOfService() {
        // Open ToS
    }
    
    func openPrivacy() {
        // Open Privacy
    }
    
}
