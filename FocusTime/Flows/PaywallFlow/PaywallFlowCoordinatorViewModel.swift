//
//  PaywallFlowViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.06.2025.
//

import Foundation

enum PaywallScreens: Equatable {
    case freePlan(_ viewModel: FreePlanUpgradeViewModel)
    case onboarding
    case planSelection
    
    var id: Self { self }
    
    static func == (lhs: PaywallScreens, rhs: PaywallScreens) -> Bool {
        switch (lhs, rhs) {
        case (.freePlan, .freePlan): true
        case (.onboarding, .onboarding): true
        case (.planSelection, .planSelection): true
        default: false
        }
    }
}

@MainActor
@Observable
final class PaywallFlowCoordinatorViewModel {
    struct State {
        var currentFlow: PaywallScreens
        
        init(currentFlow: PaywallScreens) {
            self.currentFlow = currentFlow
        }
    }
    
    private(set) var flowState: State!
    private var factory: PaywallBusinessLogicFactory
    
    init(
//        flowState: State = State(),
        factory: PaywallBusinessLogicFactory
    ) {
        self.factory = factory
        self.flowState = State(currentFlow: .freePlan(self.makeFreePlanUpgradeViewModel()))
    }
    
    private func getTrialProductID() -> String {
        StoreKitProductIdentifiers.trialableWeekly.id
    }
    
    func makeFreePlanUpgradeViewModel() -> FreePlanUpgradeViewModel {
        let trialProductID = getTrialProductID()
        return factory.makeFreePlanUpgradeViewModel(requestedProductID: trialProductID, flowDelegate: self)
    }
    
    func makeOnboardingPaywallViewModel() -> OnboardingPaywallViewModel {
        let trialProductID = getTrialProductID()
        return factory.makeOnboardingPaywallViewModel(requestedProductID: trialProductID, flowDelegate: self)
    }
    
    func makePlanSelectionPaywallViewModel() -> PlanSelectionPaywallViewModel {
        return factory.makePlanSelectionViewModel(flowDelegate: self)
    }
    
}

extension PaywallFlowCoordinatorViewModel: PaywallNavigationDelegate {
    func paywallDidRequestTermsOfService() {
        #warning("No implementation")
        print("ToS requested")
    }
    
    func paywallDidRequestPrivacyPolicy() {
        #warning("No implementation")
        print("Privacy requested")
    }
    
    func paywallDidRequestPlanSelection() {
        flowState.currentFlow = .planSelection
    }
    
    func paywallDidRequestDismissal() {
        #warning("No implementation")
        print("Dismissal requested")
    }
}
