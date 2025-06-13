//
//  AppFlow.swift
//  FocusTime
//
//  Created by Keto Nioradze on 05.06.25.
//

import Foundation
import Observation

enum AppFlow: Hashable {
    /// Initial state, perhaps for loading resources
    case launch
    case onboarding
    case main
}

@MainActor
@Observable
class AppFlowCoordinatorViewModel {
    
    struct State {
        var currentFlow: AppFlow = .launch
    }
    
    private(set) var state = State()

    let onboardingStatusProvider: OnboardingStatusManager
    private let analyticsManager: AnalyticsManager

    init(onboardingStatusProvider: OnboardingStatusManager, analyticsManager: AnalyticsManager) {
        self.onboardingStatusProvider = onboardingStatusProvider
        self.analyticsManager = analyticsManager
        
        self.onboardingStatusProvider.delegate = self
        determineCurrentFlow()
    }

    func determineCurrentFlow() {
        let isOnboardingCompleted = self.onboardingStatusProvider.hasCompletedOnboarding
        let previousFlow = self.state.currentFlow

        switch previousFlow {
        case .launch:
            self.state.currentFlow = isOnboardingCompleted ? .main : .onboarding
            
        case .onboarding where isOnboardingCompleted:
            self.state.currentFlow = .main
            
        case .main where !isOnboardingCompleted:
            self.state.currentFlow = .onboarding
            
        default:
            break
        }
        
        if previousFlow != self.state.currentFlow {
            print("AppFlow changed from \(previousFlow) to: \(self.state.currentFlow) (Onboarding completed: \(isOnboardingCompleted))")
        } else {
            print("AppFlow re-evaluated, remains: \(self.state.currentFlow) (Onboarding completed: \(isOnboardingCompleted))")
        }
    }

    
    func resetOnboarding() {
        print("AppFlowCoordinatorViewModel: Resetting onboarding status to false.")
        onboardingStatusProvider.hasCompletedOnboarding = false
    }
}


// Extensions
extension AppFlowCoordinatorViewModel: OnboardingCoordinatorDelegate {
    func onboardingDidComplete() {
        onboardingStatusProvider.hasCompletedOnboarding = true
        print("AppFlowCoordinatorViewModel: Onboarding completed, setting status to true.")
    }
}

extension AppFlowCoordinatorViewModel: OnboardingStatusManagerDelegate {
    func onboardingStatusDidChange() {
        self.determineCurrentFlow()
    }
}
