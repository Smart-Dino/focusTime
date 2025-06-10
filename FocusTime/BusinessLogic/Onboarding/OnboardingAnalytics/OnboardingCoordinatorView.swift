//
//  OnboardingCoordinatorView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 30.05.25.
//

import SwiftUI

enum OnboardingNavigationPath: Hashable {
    case slides
}

struct OnboardingCoordinatorView: View {
    @State private var viewModel: OnboardingCoordinatorViewModel

    init(onComplete: @escaping () -> Void, analyticsManager: AnalyticsManager) {
        self._viewModel = State(wrappedValue: OnboardingCoordinatorViewModel(
            onComplete: onComplete,
            analyticsManager: analyticsManager
        ))
        print("OnboardingCoordinatorView initialized.")
    }

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            QuizOnboardingView(
                viewModel: QuizOnboardingViewModel(
                    analyticsManager: viewModel.analyticsManager,
                    onNext: viewModel.showSlides
                )
            )
            .navigationDestination(for: OnboardingNavigationPath.self) { pathValue in
                switch pathValue {
                case .slides:
                    SlideOnboardingView(
                        viewModel: SlideOnboardingViewModel(
                            analyticsManager: viewModel.analyticsManager,
                            onOnboardingCompleted: viewModel.onboardingCompleted
                        )
                    )
                }
            }
        }
    }
}
