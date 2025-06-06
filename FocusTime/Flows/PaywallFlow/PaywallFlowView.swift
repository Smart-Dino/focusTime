//
//  PaywallFlowView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.06.2025.
//

import SwiftUI

struct PaywallFlowView: View {
    @State var viewModel: PaywallFlowViewModel
    
    var body: some View {
        Group {
            switch viewModel.state.currentPaywall {
            case .freePlan:
                FreePlanUpgradeView(
                    viewModel: viewModel.makeFreePlanUpgradeViewModel()
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
}

#Preview {
    PaywallFlowView(viewModel: .init(paymentManager: MockPaymentManagerWithPurchaseError()))
}
