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
        FreePlanUpgradeViewModel(requestedProductID: requestedProductID, superPaywallVM: superPaywallVM)
    }
    
    func makeOnboardingPaywallViewModel(requestedProductID: String) -> OnboardingPaywallViewModel {
        OnboardingPaywallViewModel(requestedProductID: requestedProductID, superPaywallVM: superPaywallVM)
    }
    
    func makePlanSelectionViewModel() -> PlanSelectionPaywallViewModel {
        PlanSelectionPaywallViewModel(superPaywallVM: superPaywallVM)
    }
    
}
