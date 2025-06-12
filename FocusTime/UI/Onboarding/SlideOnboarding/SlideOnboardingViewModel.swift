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
    
    enum OnboardingAlertType: Identifiable {
        case skipConfirmation
        var id: Self { self }
    }
    
    struct State {
        var currentIndex: Int = 0

        var alertType: OnboardingAlertType? = nil
        
        var currentStep: SlideOnboardingStep {
            SlideOnboardingStep.allCases[currentIndex]
        }
        
        
    }

    private(set) var state = State()
    private let analyticsManager: AnalyticsManager
    private weak var delegate: SlideOnboardingViewModelDelegate?

    init(analyticsManager: AnalyticsManager, delegate: SlideOnboardingViewModelDelegate?) {
        self.analyticsManager = analyticsManager
        self.delegate = delegate
        logSlideViewed(step: state.currentStep, index: state.currentIndex)
        print("SlideOnboardingViewModel initialized.")
    }

    private func logSlideViewed(step: SlideOnboardingStep, index: Int) {
        analyticsManager.log(event: .onboardingSlideViewed(slideName: step.subtitle1, slideIndex: index))
    }

    func goToNextStep() {
        let previousStepName = state.currentStep.subtitle1
        let previousStepIndex = state.currentIndex
        if state.currentIndex < SlideOnboardingStep.allCases.count - 1 {
            state.currentIndex += 1
            analyticsManager.log(
                event: .onboardingNextSlideTapped(
                    fromSlideName: previousStepName, fromSlideIndex: previousStepIndex
                )
            )
            logSlideViewed(step: state.currentStep, index: state.currentIndex)
        }
    }

    func skipOnboardingInitiated() {
        analyticsManager.log(event: .onboardingSkipInitiated(fromSlideName: state.currentStep.subtitle1, fromSlideIndex: state.currentIndex))
        state.alertType = .skipConfirmation
    }

    func skipOnboardingConfirmed() {
        analyticsManager.log(event: .onboardingSkipConfirmed(fromSlideName: state.currentStep.subtitle1, fromSlideIndex: state.currentIndex))
    }

    func dismissAlert() {
        state.alertType = nil
    }
    
    func completeOnboarding() {
        analyticsManager.log(event: .onboardingCompleted(lastSlideName: state.currentStep.subtitle1))
        print("SlideOnboardingViewModel: completeOnboarding called. Triggering onOnboardingCompleted callback.")
        self.delegate?.didCompleteOnboarding()
    }
}
