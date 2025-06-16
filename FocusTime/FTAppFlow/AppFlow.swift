//
//  AppFlow.swift
//  FocusTime
//
//  Created by Keto Nioradze on 05.06.25.
//

import Foundation

enum AppFlow: Hashable {
    /// Initial state, perhaps for loading resources
    case launch
    case onboarding(OnboardingCoordinatorViewModel)
    case main
    
    
    static func == (lhs: AppFlow, rhs: AppFlow) -> Bool {
        switch (lhs, rhs) {
        case (.launch, .launch):
            return true
        case (.onboarding, .onboarding):
            return true
        case (.main, .main):
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .launch:
            hasher.combine(0)
        case .onboarding:
            hasher.combine(1)
        case .main:
            hasher.combine(2)
        }
    }
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
            let progress = self.onboardingStatusProvider.onboardingProgress
            let previousFlow = self.state.currentFlow
            let newFlow: AppFlow
            
            switch progress {
            case .completed:
                newFlow = .main
            case .quiz, .slides:
                let onboardingViewModel = OnboardingCoordinatorViewModel(
                    startingProgress: progress,
                    delegate: self,
                    analyticsManager: self.analyticsManager
                )
                newFlow = .onboarding(onboardingViewModel)
            }

        switch (newFlow, previousFlow) {
         case (.main, .main),
              (.onboarding, .onboarding),
              (.launch, .launch):
             print("AppFlow re-evaluated, remains: \(self.state.currentFlow) (Onboarding progress: \(progress))")
         default:
             self.state.currentFlow = newFlow
             print("AppFlow changed to: \(self.state.currentFlow) (Onboarding progress: \(progress))")
         }
     }
    
    func resetOnboarding() {
         print("AppFlowCoordinatorViewModel: Resetting onboarding status to false.")
         onboardingStatusProvider.onboardingProgress = .quiz
     }
 }


// Extensions
extension AppFlowCoordinatorViewModel: OnboardingCoordinatorDelegate {
    func quizFlowDidFinish() {
        onboardingStatusProvider.onboardingProgress = .slides
        print("AppFlowCoordinatorViewModel: Quiz finished, saving progress as .slides")
    }

    func onboardingDidComplete() {
        onboardingStatusProvider.onboardingProgress = .completed
        print("AppFlowCoordinatorViewModel: Onboarding completed, saving progress as .completed.")
    }
}

extension AppFlowCoordinatorViewModel: OnboardingStatusManagerDelegate {
    func onboardingStatusDidChange() {
        self.determineCurrentFlow()
    }
}
