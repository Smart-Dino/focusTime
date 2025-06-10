//
//  OnboardingCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 09.06.25.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class OnboardingCoordinatorViewModel {
    var path: [OnboardingNavigationPath] = []

    let onComplete: () -> Void
    let analyticsManager: AnalyticsManager

    init(onComplete: @escaping () -> Void, analyticsManager: AnalyticsManager) {
        self.onComplete = onComplete
        self.analyticsManager = analyticsManager
    }

    func showSlides() {
        path.append(.slides)
    }

    func onboardingCompleted() {
        print("SlideOnboardingView signaled completion.")
        onComplete()
    }
}
