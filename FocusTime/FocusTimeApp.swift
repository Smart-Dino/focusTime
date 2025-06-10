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
    private let appFlowViewModel: AppFlowViewModel

    init() {
        self.analyticsManager = LoggingAnalyticsManager()
        self.onboardingStatusManager = OnboardingStatusManager()
        self.appFlowViewModel = AppFlowViewModel(
            onboardingStatusProvider: onboardingStatusManager,
            analyticsManager: analyticsManager
        )
        print("FocusTimeApp initialized. Initial onboarding status: \(onboardingStatusManager.hasCompletedOnboarding)")
    }

    var body: some Scene {
        WindowGroup {
            AppFlowControlView(
                viewModel: appFlowViewModel,
                analyticsManager: analyticsManager 
            )
        }
    }
}
