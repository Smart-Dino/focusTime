//
//  OnboardingCoordinatorView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 30.05.25.
//

import SwiftUI

enum OnboardingNavigationPath: Hashable {
    case quiz
    case slides
}

struct OnboardingCoordinatorView: View {
    @Binding var hasCompletedOnboarding: Bool
    // TODO: use NavigationStack for iOS 17+
    @State private var navigationPath = NavigationPath()

    private let analyticsManager: AnalyticsManaging = AppAnalytics.shared

    var body: some View {
        NavigationStack(path: $navigationPath) {
            QuizOnboardingView(
                viewModel: QuizOnboardingViewModel(
                    analyticsManager: analyticsManager,
                    onNext: {
                        navigationPath.append(OnboardingNavigationPath.slides)
                    }
                )
            )
            .navigationDestination(for: OnboardingNavigationPath.self) { pathValue in
                switch pathValue {
                case .quiz:
                    QuizOnboardingView(
                        viewModel: QuizOnboardingViewModel(
                            analyticsManager: analyticsManager,
                            onNext: { navigationPath.append(OnboardingNavigationPath.slides) }
                        )
                    )
                case .slides:
                    SlideOnboardingView(
                        viewModel: SlideOnboardingViewModel(analyticsManager: analyticsManager),
                        hasCompletedOnboarding: $hasCompletedOnboarding
                    )
                }
            }
        }
    }
}
