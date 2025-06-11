//
//  PaywallFlowView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.06.2025.
//

import SwiftUI

struct PaywallFlowCoordinatorView: View {
    @State var viewModel: PaywallFlowCoordinatorViewModel
    
    var body: some View {
        let _ = Self._printChanges()
        NavigationStack {
            Group {
                switch viewModel.flowState.currentFlow {
                case .freePlan(let freePlanModel):
                    FreePlanUpgradeView(
                        viewModel: freePlanModel
                    )
                case .onboarding:
                    OnboardingPaywallView(
                        viewModel: viewModel.makeOnboardingPaywallViewModel()
                    )
                case .planSelection:
                    PlanSelectionPaywallView(
                        viewModel: viewModel.makePlanSelectionPaywallViewModel()
                    )
                }
            }
            .preferredColorScheme(.dark)
        }
//        .animation(.default, value: viewModel.flowState.currentFlow)
    }
}

#Preview {
    let paymentManager = MockPaymentManagerWithPurchaseError()
    let superVM = SuperPaywallViewModel(paymentManager: paymentManager)
    let factory = PaywallBusinessLogicFactory(paymentManager: paymentManager,
                                              superPaywallVM: superVM)
    PaywallFlowCoordinatorView(
        viewModel: .init(factory: factory)
    )
}
