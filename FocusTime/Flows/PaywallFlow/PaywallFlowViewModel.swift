//
//  PaywallFlowViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.06.2025.
//

import Foundation

enum PaywallSreens: Identifiable, Hashable {
    case freePlan
    case onboarding
    case planSelection
    
    var id: Self { self }
}

@MainActor
@Observable
final class PaywallFlowViewModel {
    struct State {
        var currentPaywall: PaywallSreens = .planSelection
    }
    
    private(set) var state: State
    private var factory: PaywallBusinessLogicFactory
    
    init(
        state: State = State(),
        paymentManager: PaymentManager
    ) {
        self.state = state
        self.factory = PaywallBusinessLogicFactory(paymentManager: paymentManager)
    }
    
    private func getTrialProductID() -> String {
        StoreKitProductIdentifiers.trialableWeekly.id
    }
    
    func makeFreePlanUpgradeViewModel() -> FreePlanUpgradeViewModel {
        let trialProductID = getTrialProductID()
        return factory.makeFreePlanUpgradeViewModel(requestedProductID: trialProductID)
    }
    
    func makeOnboardingPaywallViewModel() -> OnboardingPaywallViewModel {
        let trialProductID = getTrialProductID()
        return factory.makeOnboardingPaywallViewModel(requestedProductID: trialProductID)
    }
    
    func makePlanSelectionPaywallViewModel() -> PlanSelectionPaywallViewModel {
        return factory.makePlanSelectionViewModel()
    }
    
}
