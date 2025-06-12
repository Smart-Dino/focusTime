//
//  FTNavigationDelegates.swift
//  FocusTime
//
//  Created by Keto Nioradze on 12.06.25.
//

import Foundation


@MainActor
protocol AnalyticsManager: Sendable {
    func log(event: AnalyticsEvent)
}

@MainActor
protocol OnboardingStatusProviding: Sendable {
    @MainActor var hasCompletedOnboarding: Bool { get set }
}


@MainActor
protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingDidComplete()
}

@MainActor
protocol OnboardingStatusManagerDelegate: AnyObject {
    func onboardingStatusDidChange()
}

@MainActor
protocol QuizOnboardingViewModelDelegate: AnyObject {
    func didTapNext()
}

@MainActor
protocol SlideOnboardingViewModelDelegate: AnyObject {
    func didCompleteOnboarding()
}
