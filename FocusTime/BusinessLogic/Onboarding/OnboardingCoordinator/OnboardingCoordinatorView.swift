//
//  OnboardingCoordinatorView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 30.05.25.
//

import SwiftUI

enum OnboardingNavigationPath: Hashable {
    case onboardingSlidesPath
}

struct OnboardingCoordinatorView: View {
    @State private var viewModel: OnboardingCoordinatorViewModel

    init(delegate: OnboardingCoordinatorDelegate?, analyticsManager: AnalyticsManager) {
        self._viewModel = State(wrappedValue: OnboardingCoordinatorViewModel(
            delegate: delegate,
            analyticsManager: analyticsManager
        ))
        print("OnboardingCoordinatorView initialized.")
    }

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            QuizOnboardingView(
                viewModel: QuizOnboardingViewModel(
                    analyticsManager: viewModel.analyticsManager,
                    delegate: viewModel
                )
            )
            .navigationDestination(for: OnboardingNavigationPath.self) { pathValue in
                switch pathValue {
                case .onboardingSlidesPath:
                    SlideOnboardingView(
                        viewModel: SlideOnboardingViewModel(
                            analyticsManager: viewModel.analyticsManager,
                            delegate: viewModel
                        )
                    )
                }
            }
        }
    }
}
