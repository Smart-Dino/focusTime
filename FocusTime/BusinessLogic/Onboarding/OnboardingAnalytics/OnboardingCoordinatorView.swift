//
//  OnboardingCoordinatorView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 30.05.25.
//

import SwiftUI

// Manages the navigation flow for the onboarding sequence.
// It uses SwiftUI's NavigationStack to present different onboarding views (Quiz and Slides).

enum OnboardingNavigationPath: Hashable {
    case slides
}

struct OnboardingCoordinatorView: View {
    @Binding var hasCompletedOnboarding: Bool

    @State private var path: [OnboardingNavigationPath] = []


    private let analyticsManager: AnalyticsManaging = AppAnalytics.shared

    var body: some View {

        NavigationStack(path: $path) {
            QuizOnboardingView(
                viewModel: QuizOnboardingViewModel(
                    analyticsManager: analyticsManager,
                    onNext: {

                        path.append(OnboardingNavigationPath.slides)
                    }
                )
            )

            .navigationDestination(for: OnboardingNavigationPath.self) { pathValue in
                switch pathValue {
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
