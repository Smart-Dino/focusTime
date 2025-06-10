//
//  AppFlow.swift
//  FocusTime
//
//  Created by Keto Nioradze on 05.06.25.
//

import Foundation
import Observation

enum AppFlow: Hashable {
    case launch // Initial state, perhaps for loading resources
    case onboarding
    case main
}

@MainActor
@Observable
class AppFlowViewModel {
    var currentFlow: AppFlow = .launch

    let onboardingStatusProvider: OnboardingStatusManager
    private let analyticsManager: AnalyticsManager

    init(onboardingStatusProvider: OnboardingStatusManager, analyticsManager: AnalyticsManager) {
        self.onboardingStatusProvider = onboardingStatusProvider
        self.analyticsManager = analyticsManager
        
        self.onboardingStatusProvider.onStatusDidChange = { [weak self] in
            self?.determineCurrentFlow()
        }
        determineCurrentFlow()
    }

    func determineCurrentFlow() {
        let isOnboardingCompleted = self.onboardingStatusProvider.hasCompletedOnboarding
        let previousFlow = self.currentFlow

        if self.currentFlow == .launch {
            if isOnboardingCompleted {
                self.currentFlow = .main
            } else {
                self.currentFlow = .onboarding
            }
        } else if self.currentFlow == .onboarding && isOnboardingCompleted {
            self.currentFlow = .main
        } else if self.currentFlow == .main && !isOnboardingCompleted {
            self.currentFlow = .onboarding
        }
        
        if previousFlow != self.currentFlow {
             print("AppFlow changed from \(previousFlow) to: \(self.currentFlow) (Onboarding completed: \(isOnboardingCompleted))")
        } else {
             print("AppFlow re-evaluated, remains: \(self.currentFlow) (Onboarding completed: \(isOnboardingCompleted))")
        }
    }

    func completeOnboarding() {
        print("AppFlowViewModel: Onboarding completed, setting status to true.")
        onboardingStatusProvider.hasCompletedOnboarding = true
    }
    
    func resetOnboarding() {
        print("AppFlowViewModel: Resetting onboarding status to false.")
        onboardingStatusProvider.hasCompletedOnboarding = false
    }
}
