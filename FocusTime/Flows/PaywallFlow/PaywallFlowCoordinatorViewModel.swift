//
//  PaywallFlowViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.06.2025.
//

import Foundation

enum PaywallScreen: Equatable {
    case freePlan(_ viewModel: FreePlanUpgradeViewModel)
    case onboarding(_ viewModel: OnboardingPaywallViewModel)
    case planSelection(_ viewModel: PlanSelectionPaywallViewModel)
    
    var id: Self { self }
    
    static func == (lhs: PaywallScreen, rhs: PaywallScreen) -> Bool {
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
        var currentFlow: PaywallScreen
    }
    private(set) var flowState: State!
    
    private let trialProductID: String
    private let superPaywallVM: SuperPaywallViewModel
    
    init(
        trialProductID: StoreKitProductIdentifiers = .trialableWeekly,
        superPaywallVM: SuperPaywallViewModel
    ) {
        self.trialProductID = trialProductID.id
        self.superPaywallVM = superPaywallVM
        self.flowState = State(
//            currentFlow: .freePlan(self.makeFreePlanUpgradeViewModel(requestedProductID: self.tiralProductID))
//            currentFlow: .onboarding(self.makeOnboardingPaywallViewModel(requestedProductID: self.tiralProductID))
            currentFlow: .planSelection(self.makePlanSelectionPaywallViewModel())
        )
    }
    
    func makeFreePlanUpgradeViewModel(requestedProductID: String) -> FreePlanUpgradeViewModel {
        FreePlanUpgradeViewModel(
            state: .init(requestedProductID: requestedProductID),
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
    }
    
    func makeOnboardingPaywallViewModel(requestedProductID: String) -> OnboardingPaywallViewModel {
        OnboardingPaywallViewModel(
            state: .init(requestedProductID: requestedProductID),
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
    }
    
    func makePlanSelectionPaywallViewModel() -> PlanSelectionPaywallViewModel {
        PlanSelectionPaywallViewModel(
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
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
        flowState.currentFlow = .planSelection(self.makePlanSelectionPaywallViewModel())
    }
    
    func paywallDidRequestDismissal() {
        #warning("No implementation")
        print("Dismissal requested")
    }
}
