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
    
    init(
        state: State = State(),
        legalService: LegalService = LiveLegalService(),
        paymentManager: PaymentManager,
    ) {
        self.state = state
        self.legalService = legalService
        self.paymentManager = paymentManager
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
        Task {
            do {
                try await paymentManager.restorePurchases()
            } catch {
                state.error = error
            }
        }
    }
    
    func openTermsOfService() {
        Task {
            do {
                state.legalResult = try await legalService.requestContents(for: .termsOfService)
            } catch {
                state.error = error
            }
        }
    }
    
    func openPrivacy() {
        Task {
            do {
                state.legalResult = try await legalService.requestContents(for: .privacyPolicy)
            } catch {
                state.error = error
            }
        }
    }
    
}
