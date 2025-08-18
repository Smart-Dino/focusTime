//
//  AppFlowCoordinatorView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import SwiftUI

struct AppFlowCoordinatorView: View {
    @State var viewModel: AppFlowCoordinatorViewModel
    
    var body: some View {
        Group {
            switch viewModel.state.currentFlow {
            case .onboarding(let onboardingFlowViewModel):
                OnboardingFlowCoordinatorView(viewModel: onboardingFlowViewModel)
            case .main(let mainFlowViewModel):
                MainFlowCoordinatorView(viewModel: mainFlowViewModel)
                    .task { await viewModel.showFreePlanCoverIfNeeded() }
            }
        }
        .fullScreenCover(
            item: Binding(
                get: { viewModel.state.screenCover },
                set: { viewModel.setScreenCover(to: $0) }
            )
        ) { cover in
            NavigationStack {
                // Full screen cover makes view .opAppear get called twice.
                // And the first time it does that it produces very unexpected results.
                // So make sure you setup your data in a ViewModel instead.
                switch cover {
                case .freePlanPaywall(let freePlanPaywallViewModel):
                    FreePlanUpgradeView(viewModel: freePlanPaywallViewModel)
                case .onboardingPaywall(let onboardingPaywallViewModel):
                    OnboardingPaywallView(viewModel: onboardingPaywallViewModel)
                case .planSelectionPaywall(let planSelecitonPaywallViewModel):
                    PlanSelectionPaywallView(viewModel: planSelecitonPaywallViewModel)
                }
            }
        }
    }
}

#Preview {
    let defaultsManager = LiveDefaultsManager()
    AppFlowCoordinatorView(
        viewModel: .init(
            defaultsManager: defaultsManager,
            modelContainer: PreviewData.memoryOnlyModelContainer,
            paymentManager: MockPaymentManagerWithPurchaseError()
        )
    )
}
