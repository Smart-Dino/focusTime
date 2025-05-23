//
//  OnboardingPaywallViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import Foundation
import StoreKit

/// ViewModel, responsible for managing the logic on ``OnboardingPaywallView``.
/// - Note: Use it in the ``OnboadingPaywallView``.
@MainActor
@Observable
final class OnboardingPaywallViewModel {
    // MARK: - Nested declarations
    struct State {
        var error: Error?
        /// Main features of the paid version,
        let featureItems = OnboardingPaywallView.Constants.FeatureItems.allCases
        
        var formattedPrice: String?
        var trialTerms: String {
            "3-day free trial, then \(formattedPrice ?? "...") / month, cancel anytime"
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
    func fetchPrice(for period: PeriodConverter) async throws -> String? {
        let products = try await paymentManager.getProducts()
        
        if let targetProduct = products.first(
            where: { $0.subscriptionPeriod == period.durationInSeconds }
        ) {
            let formatter = FTProductFormatter(targetProduct)
            return formatter.priceString
        }
        throw NSError()
    }

    func loadPricing(for period: PeriodConverter) {
        Task {
            do {
                if let priceDescription = try await fetchPrice(for: period) {
                    state.formattedPrice = priceDescription
                }
            } catch {
                state.error = error
            }
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
