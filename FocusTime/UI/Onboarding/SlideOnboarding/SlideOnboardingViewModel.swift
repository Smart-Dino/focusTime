//
//  SlideOnboardingViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 19.05.25.
//

// OnboardingViewModel.swift

import Observation

@MainActor
@Observable
final class SlideOnboardingViewModel {
    
    struct State {
        var currentIndex: Int = 0
        var showSkipConfirmation: Bool = false
    }

    var state = State()
    private let analyticsManager: AnalyticsManaging

    var currentStep: SlideOnboardingStep {
        SlideOnboardingStep.allCases[state.currentIndex]
    }
    
    var currentStepIndex: Int {
        state.currentIndex
    }

    init(analyticsManager: AnalyticsManaging = AppAnalytics.shared) {
        self.analyticsManager = analyticsManager
        logSlideViewed(step: currentStep, index: state.currentIndex)
    }
    
    private func logSlideViewed(step: SlideOnboardingStep, index: Int) {
        analyticsManager.log(event: .onboardingSlideViewed(slideName: step.subtitle1, slideIndex: index))
    }

    func goToNextStep() {
        let previousStepName = currentStep.subtitle1
        let previousStepIndex = state.currentIndex
        if state.currentIndex < SlideOnboardingStep.allCases.count - 1 {
            state.currentIndex += 1
            analyticsManager.log(event: .onboardingNextSlideTapped(fromSlideName: previousStepName, fromSlideIndex: previousStepIndex))
            logSlideViewed(step: currentStep, index: state.currentIndex)
        }
    }

    func skipOnboardingInitiated() {
        analyticsManager.log(event: .onboardingSkipInitiated(fromSlideName: currentStep.subtitle1, fromSlideIndex: state.currentIndex))
        state.showSkipConfirmation = true
    }

    func skipOnboardingConfirmed() {
        analyticsManager.log(event: .onboardingSkipConfirmed(fromSlideName: currentStep.subtitle1, fromSlideIndex: state.currentIndex))

    }

    func completeOnboarding() {
        if currentStep.isLast {
            analyticsManager.log(event: .onboardingCompleted(lastSlideName: currentStep.subtitle1))
        }
    }
}
