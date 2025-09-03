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
            case .splash(let viewModel):
                SplashScreenView(viewModel: viewModel)
            default: Text("There was an error figuring out the screen to show:(")
            }
        }
        .fullScreenCover(
            item: .binding(
                get: viewModel.state.screenCover,
                set: viewModel.setScreenCover(to:)
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
                case .planSelectionPaywall(let planSelectionPaywallViewModel):
                    PlanSelectionPaywallView(viewModel: planSelectionPaywallViewModel)
                }
            }
        }
    }
}

#Preview {
    let viewModel = AppFlowCoordinatorViewModel(
        defaultsManager: PreviewData.mockDefaultsManager,
        paymentManagerFactory: PreviewData.mockPaymentManagerFactory,
        persistenceStoreFactory: PreviewData.mockPersistenceStoreFactory
    )
    
    return AppFlowCoordinatorView(viewModel: viewModel)
        .preferredColorScheme(.dark)
}
