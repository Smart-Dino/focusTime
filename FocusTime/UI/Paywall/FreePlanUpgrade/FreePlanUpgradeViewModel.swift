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
        var subscriptionTask: Task<Void, Never>?
        
        var trialProduct: FTProduct
        var purchaseResult: FTProduct.PurchaseResult?
        
        var isButtonDisabled: Bool = true
        var purchaseButtonTitle = FreePlanUpgradeView.Constants.Strings.tryButtonTitle
        var formattedPrice: String?
        var trialPeriodDescription: String = FreePlanUpgradeView.Constants.Strings.paidOnce
    }
    
    // MARK: - Properties
    /// Property contatining values that may trigger UI redraw.
    private(set) var state: State
    
    // Made this property private becase it is injected
    // through the initializer, not a property.
    private let paymentManager: PaymentManager
    
    // MARK: - Initializers
    init(
        trialableProduct: FTProduct,
        paymentManager: PaymentManager
    ) {
        // ViewModel init
        self.state = State(trialProduct: trialableProduct)
        self.paymentManager = paymentManager
        
        // State init
        self.state.trialProduct = trialableProduct
    }
    
    // A deinitializer is called immediately before a class instance is deallocated
    // - so we should have access to self.state before it deinits?
    deinit {
        Task { [weak self] in
            await self?.state.subscriptionTask?.cancel()
        }
    }
    
    // MARK: - State setter methods
    func updateError(showError: Bool) {
        if !showError {
            state.error = nil
        }
    }
    
    // MARK: - Methods
    // MARK: Setup
    func startListeningToSubscriptionUpdates() {
        state.subscriptionTask?.cancel()
        
        state.subscriptionTask = Task { [weak self] in
            guard let self else { return }
            for await update in await self.paymentManager.updatesStream() {
                if update == .internalUpdate {
                    self.updatePurchaseResult()
                }
            }
        }
    }
    
    func setupProductInfo() {
        print("Setup product info")
        let trialProduct = state.trialProduct
        guard trialProduct.trialPeriod != nil else {
            state.error = FreePlanUpgradeError.invalidProduct
            // Dismiss view?
            return
        }
        
        let price = trialProduct.priceString
        let period = trialProduct.periodString ?? ""
        state.formattedPrice = period.isEmpty ? price : "\(price) / \(period)"
        
        if let description = trialProduct.trialPeriodDescription {
            state.trialPeriodDescription = description
        }
        state.trialProduct = trialProduct
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
            state.purchaseButtonTitle = FreePlanUpgradeView.Constants.Strings.tryButtonTitle
            state.isButtonDisabled = false
            return
        }

        switch result {
        case .success:
            state.purchaseButtonTitle = FreePlanUpgradeView.Constants.Strings.subscribedMessage
            state.isButtonDisabled = true
            state.error = nil

        case .pending:
            state.purchaseButtonTitle = FreePlanUpgradeView.Constants.Strings.pendingMessage
            state.isButtonDisabled = true
            state.error = PaymentError.pending

        case .userCancelled:
            state.purchaseButtonTitle = FreePlanUpgradeView.Constants.Strings.tryButtonTitle
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
