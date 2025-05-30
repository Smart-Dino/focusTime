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
        
        var trialProduct: FTProduct?
        var isSubscribed: Bool = false
        
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
        state: State = State(),
        paymentManager: PaymentManager
    ) {
        self.state = state
        self.paymentManager = paymentManager
    }
    
    // MARK: - State setter methods
    func updateError(showError: Bool) {
        if !showError {
            state.error = nil
        }
    }
    
    // MARK: - Methods
    func viewAllPlans() {
        // Show all plans
    }
    
    func startListeningToSubscriptionUpdates() async {
        let stream = await paymentManager.stream()
        for await update in stream {
            if let trialProduct = state.trialProduct {
                state.isSubscribed = await paymentManager.isPurchased(trialProduct)
            }
        }
    }
    
    func loadFirstTrialOffer() async {
        let products = await paymentManager.products

        guard let trialProduct = products.first(where: { $0.trialPeriod != nil }) else {
            state.error = OnboardingPaywallError.noTrialOption
            return
        }

        let price = trialProduct.priceString
        let period = trialProduct.periodString ?? ""
        state.formattedPrice = period.isEmpty ? price : "\(price) / \(period)"

        if let description = trialProduct.trialPeriodDescription {
            state.trialPeriodDescription = description
        }
        
        state.isSubscribed = await paymentManager.isPurchased(trialProduct)

        state.trialProduct = trialProduct
    }

    
    func subscribeToFreeTrial() {
            guard let product = state.trialProduct else {
                state.error = OnboardingPaywallError.noTrialOption
                return
            }
            Task {
                do {
                    let _ = try await paymentManager.purchase(product)
                } catch {
                    state.error = error
                }
            }
        }
    
    func restorePurchase() {
        // I've decided to make this method sync to keep the visual harmony of
        // SubscriptionUtilityLinksView(
        //      onTermsTapped: viewModel.openTermsOfService,
        //      onPrivacyTapped: viewModel.openPrivacy,
        //      onRestoreTapped: viewModel.restorePurchase
        // )
        Task {
            do {
                try await paymentManager.restorePurchases()
            } catch {
                state.error = error
            }
        }
    }
    
    func openTermsOfService() {
        // Open ToS
    }
    
    func openPrivacy() {
        // Open Privacy
    }
    
}

