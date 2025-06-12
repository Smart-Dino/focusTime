//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI

@main
struct FocusTimeApp: App {
    private let analyticsManager: AnalyticsManager
    private let onboardingStatusManager: OnboardingStatusManager
    private let appFlowCoordinatorViewModel: AppFlowCoordinatorViewModel

    init() {
        self.analyticsManager = MockLoggingAnalyticsManager()
        self.onboardingStatusManager = OnboardingStatusManager()
        self.appFlowCoordinatorViewModel = AppFlowCoordinatorViewModel(
            onboardingStatusProvider: onboardingStatusManager,
            analyticsManager: analyticsManager
        )
        print("FocusTimeApp initialized. Initial onboarding status: \(onboardingStatusManager.hasCompletedOnboarding)")
    }

    var body: some Scene {
        WindowGroup {
            AppFlowCoordinatorView(
                viewModel: appFlowCoordinatorViewModel,
                analyticsManager: analyticsManager
            )
        }
    }
}
