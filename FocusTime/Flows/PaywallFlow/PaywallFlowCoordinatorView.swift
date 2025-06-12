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
                case .freePlan(let freePlanViewModel):
                    FreePlanUpgradeView(
                        viewModel: freePlanViewModel
                    )
                case .onboarding(let onboardingViewModel):
                    OnboardingPaywallView(
                        viewModel: onboardingViewModel
                    )
                case .planSelection(let planSelectionViewModel):
                    PlanSelectionPaywallView(
                        viewModel: planSelectionViewModel
                    )
                }
            }
            .preferredColorScheme(.dark)
        }
        .animation(.default, value: viewModel.flowState.currentFlow)
    }
}

#Preview {
    let paymentManager = MockPaymentManagerWithPurchaseError()
    let superVM = SuperPaywallViewModel(paymentManager: paymentManager)
    PaywallFlowCoordinatorView(
        viewModel: .init(superPaywallVM: superVM)
    )
}
