//
//  PaywallViewModel.swift
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
        let featureItems = OnboardingPaywallConstants.FeatureItems.allCases
    }
    
    // MARK: - Properties
    /// Property contatining values that may trigger UI redraw.
    private(set) var state: State
    
    // Made this property private becase it is injected
    // through the initializer, not a property.
    private let paymentManager: PaymentManager?
    
    // MARK: - Initializers
    init(
        state: State = State(),
        paymentManager: PaymentManager
    ) {
        self.state = state
        self.paymentManager = paymentManager
    }
    
    // MARK: - Methods
    func subscribe() {
//        Task {
//            do {
//                try await paymentManager?.purchase(Product)
//            } catch {
//                state.error = error
//            }
//        }
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
                try await paymentManager?.restorePurchases()
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
