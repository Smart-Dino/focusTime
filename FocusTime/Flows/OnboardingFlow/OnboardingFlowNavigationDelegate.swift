//
//  PaywallFlowNavigationDelegate.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import Foundation

@MainActor
protocol OnboardingFlowNavigationDelegate: AnyObject {
    func didFinishOnboarding()
}

@MainActor
protocol QuizOnboardingDelegate: AnyObject {
    func didFinishQuiz(with results: Set<QuizOnboardingView.Constants.QuizOption>)
}

@MainActor
protocol SlideOnboardingDelegate: AnyObject {
    func didFinisOnboardingSlides(skipped: Bool)
}
