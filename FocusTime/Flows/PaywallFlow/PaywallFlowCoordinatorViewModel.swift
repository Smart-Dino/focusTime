//
//  PaywallFlowViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.06.2025.
//

import Foundation

enum PaywallScreens: Identifiable, Hashable {
    case freePlan
    case onboarding
    case planSelection
    
    var id: Self { self }
}

@MainActor
@Observable
final class PaywallFlowCoordinatorViewModel {
    struct State {
        var currentFlow: PaywallScreens = .freePlan
    }
    
    private(set) var flowState: State
    private var factory: PaywallBusinessLogicFactory
    
    init(
        flowState: State = State(),
        paymentManager: PaymentManager
    ) {
        self.flowState = flowState
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
