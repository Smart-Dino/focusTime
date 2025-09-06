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
        
        var legalResult: String? = nil
    }
    
    private(set) var state: State
    private let legalService: LegalService
    private let paymentManager: PaymentManager
    
    private var analyticsManager: AnalyticsManagerProtocol
    
    init(
        state: State = State(),
        legalService: LegalService = LiveLegalService(),
        paymentManager: PaymentManager,
        analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()
    ) {
        self.state = state
        self.legalService = legalService
        self.paymentManager = paymentManager
        self.analyticsManager = analyticsManager 
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func setLegalVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.legalResult = nil
        }
    }
    
    func restorePurchase() {
        
        /// - Analytics
        analyticsManager.logEvent(name: "utility_links_restore_purchase_tapped", parameters: nil)
        
        Task {
            do {
                try await paymentManager.restorePurchases()
            } catch {
                state.error = error
            }
        }
    }
    
    func openTermsOfService() {
        
        /// - Analytics
        analyticsManager.logEvent(name: "utility_links_terms_of_service_tapped", parameters: nil)
        
        Task {
            do {
                state.legalResult = try await legalService.requestContents(for: .termsOfService)
            } catch {
                state.error = error
            }
        }
    }
    
    func openPrivacy() {
        
        /// - Analytics
        analyticsManager.logEvent(name: "utility_links_privacy_policy_tapped", parameters: nil)
        
        Task {
            do {
                state.legalResult = try await legalService.requestContents(for: .privacyPolicy)
            } catch {
                state.error = error
            }
        }
    }
    
}
