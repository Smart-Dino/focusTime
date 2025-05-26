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
        
        var formattedPrice: String?
        var trialTerms: String {
            "3-day free trial, then \(formattedPrice ?? "..."), cancel anytime"
        }
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
    
    // MARK: - Methods
    func viewAllPlans() {
        // Show all plans
    }
    
    func loadFirstTrialOffer() async {
        do {
            let products = try await paymentManager.getProducts()
            
            if let targetProduct = products.first(
                where: { $0.isTrialable }
            ) {
                let formatter = FTProductFormatter(targetProduct)
                if let periodString = formatter.periodString {
                    state.formattedPrice = formatter.priceString + " / " + periodString
                } else {
                    state.formattedPrice = formatter.priceString
                }
                return
            }
            
            state.error = OnboardingPaywallError.noTrialOption
        } catch {
            state.error = error
        }
    }

    func subscribe(with product: FTProduct) {
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

