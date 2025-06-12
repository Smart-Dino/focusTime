//
//  OnboardingCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 09.06.25.
//

import Observation

@MainActor
@Observable
final class OnboardingCoordinatorViewModel {
    var path: [OnboardingNavigationPath] = []

    weak var delegate: OnboardingCoordinatorDelegate?
    let analyticsManager: AnalyticsManager

    init(delegate: OnboardingCoordinatorDelegate?, analyticsManager: AnalyticsManager) {
        self.delegate = delegate
        self.analyticsManager = analyticsManager
    }

    func showSlides() {
        path.append(.slides)
    }
}


// Extensions
extension OnboardingCoordinatorViewModel: SlideOnboardingViewModelDelegate {
    func didCompleteOnboarding() {
        print("SlideOnboardingView signaled completion.")
        delegate?.onboardingDidComplete()
    }
}

extension OnboardingCoordinatorViewModel : QuizOnboardingViewModelDelegate {
    func didTapNext() {
        showSlides()
    }
}
