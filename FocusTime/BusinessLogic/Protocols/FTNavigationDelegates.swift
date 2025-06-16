//
//  FTNavigationDelegates.swift
//  FocusTime
//
//  Created by Keto Nioradze on 12.06.25.
//

import Foundation

@MainActor
protocol OnboardingCoordinatorDelegate: AnyObject {
    func quizFlowDidFinish()
    func onboardingDidComplete()
}

@MainActor
protocol OnboardingStatusManagerDelegate: AnyObject {
    func onboardingStatusDidChange()
}

@MainActor
protocol QuizOnboardingViewModelDelegate: AnyObject {
    func didFinishQuiz()
}

@MainActor
protocol SlideOnboardingViewModelDelegate: AnyObject {
    func didFinishSlideSequence()
}
