//
//  PaywallBusinessLogicFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.06.2025.
//

import Foundation

@MainActor
class PaywallBusinessLogicFactory {
    // MARK: - Properties
    let paymentManager: PaymentManager
    let superPaywallVM: SuperPaywallViewModel
    
    // MARK: - Initializer
    init(
        paymentManager: PaymentManager,
        superPaywallVM: SuperPaywallViewModel,
    ) {
        self.paymentManager = paymentManager
        self.superPaywallVM = superPaywallVM
    }
    
    // MARK: - Factory Methods
    func makeFreePlanUpgradeViewModel(requestedProductID: String,
                                      flowDelegate: PaywallNavigationDelegate) -> FreePlanUpgradeViewModel {
        FreePlanUpgradeViewModel(
            state: .init(requestedProductID: requestedProductID),
            superPaywallVM: superPaywallVM,
            flowDelegate: flowDelegate
        )
    }
    
    func makeOnboardingPaywallViewModel(requestedProductID: String,
                                        flowDelegate: PaywallNavigationDelegate) -> OnboardingPaywallViewModel {
        OnboardingPaywallViewModel(
            state: .init(requestedProductID: requestedProductID),
            superPaywallVM: superPaywallVM,
            flowDelegate: flowDelegate
        )
    }
    
    func makePlanSelectionViewModel(flowDelegate: PaywallNavigationDelegate) -> PlanSelectionPaywallViewModel {
        let obj = PlanSelectionPaywallViewModel(
            superPaywallVM: superPaywallVM,
            flowDelegate: flowDelegate
        )
        print("PlanSelectionPaywallViewModel initial instance:", ObjectIdentifier(obj))
        return obj
    }
    
}
