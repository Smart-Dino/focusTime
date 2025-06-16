//
//  AppFlowCoordinatorView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 05.06.25.
//

import SwiftUI

struct AppFlowCoordinatorView: View {
    @State var viewModel: AppFlowCoordinatorViewModel

    init(viewModel: AppFlowCoordinatorViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state.currentFlow {
            case .launch:
                ProgressView("Loading...")
                    .onAppear {
                        // it transitions very quickly to either onboarding or the main app based on the saved onboarding status. We've kept it as a placeholder in case we need to add any pre-loading tasks or a splash screen in the future
                    }
            case .onboarding(let onboardingViewModel):
                OnboardingCoordinatorView(viewModel: onboardingViewModel)
            case .main:
                VStack {
                    #warning("Replace with actual view")
                    ContentView()
                    Button("Reset Onboarding (for Preview)") {
                        viewModel.resetOnboarding()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
            }
        }
        .animation(.easeInOut, value: viewModel.state.currentFlow)
    }
}
