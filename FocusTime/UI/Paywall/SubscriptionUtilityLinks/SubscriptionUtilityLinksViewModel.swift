//
//  SubscriptionUtilityLinksViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.06.2025.
//

import Foundation

@MainActor
@Observable
final class SubscriptionUtilityLinksViewModel {
    struct State {
        var error: Error?
    }
    
    private(set) var state: State
    private var paymentManager: PaymentManager
    private var flowDelegate: PaywallNavigationDelegate?
    
    init(
        state: State = State(),
        paymentManager: PaymentManager,
        flowDelegate: PaywallNavigationDelegate?
    ) {
        self.state = state
        self.paymentManager = paymentManager
        self.flowDelegate = flowDelegate
    }
    
    func keepShowingError(showError: Bool) {
        if !showError {
            state.error = nil
        }
    }
    
    func restorePurchase() {
        Task {
            do {
                try await paymentManager.restorePurchases()
            } catch {
                state.error = error
            }
        }
    }
    
    func openTermsOfService() {
        flowDelegate?.paywallDidRequestTermsOfService()
    }
    
    func openPrivacy() {
        flowDelegate?.paywallDidRequestPrivacyPolicy()
    }
    
}
