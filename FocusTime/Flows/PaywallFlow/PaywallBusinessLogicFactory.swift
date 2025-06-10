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
        paymentManager: PaymentManager
    ) {
        self.paymentManager = paymentManager
        self.superPaywallVM = SuperPaywallViewModel(paymentManager: paymentManager)
    }
    
    // MARK: - Factory Methods
    func makeFreePlanUpgradeViewModel(requestedProductID: String) -> FreePlanUpgradeViewModel {
        FreePlanUpgradeViewModel(
            state: .init(requestedProductID: requestedProductID),
            superPaywallVM: superPaywallVM
        )
    }
    
    func makeOnboardingPaywallViewModel(requestedProductID: String) -> OnboardingPaywallViewModel {
        OnboardingPaywallViewModel(
            state: .init(requestedProductID: requestedProductID),
            superPaywallVM: superPaywallVM
        )
    }
    
    func makePlanSelectionViewModel() -> PlanSelectionPaywallViewModel {
        let obj = PlanSelectionPaywallViewModel(superPaywallVM: superPaywallVM)
        print("PlanSelectionPaywallViewModel initial instance:", ObjectIdentifier(obj))
        return obj
    }
    
}
