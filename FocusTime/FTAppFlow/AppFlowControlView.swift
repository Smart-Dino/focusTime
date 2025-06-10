//
//  AppFlowControlView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 05.06.25.
//

import SwiftUI

struct AppFlowControlView: View {
    @State var viewModel: AppFlowViewModel
    private let analyticsManager: AnalyticsManager

    init(viewModel: AppFlowViewModel, analyticsManager: AnalyticsManager) {
        _viewModel = State(wrappedValue: viewModel)
        self.analyticsManager = analyticsManager
    }

    var body: some View {
        Group {
            switch viewModel.currentFlow {
            case .launch:
                ProgressView("Loading...")
                    .onAppear {
                        // it transitions very quickly to either onboarding or the main app based on the saved onboarding status. We've kept it as a placeholder in case we need to add any pre-loading tasks or a splash screen in the future
                    }
            case .onboarding:
                OnboardingCoordinatorView(
                    onComplete: {
                        viewModel.completeOnboarding()
                    },
                    analyticsManager: analyticsManager
                )
            case .main:
                VStack {
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
        .animation(.easeInOut, value: viewModel.currentFlow)
    }
}
