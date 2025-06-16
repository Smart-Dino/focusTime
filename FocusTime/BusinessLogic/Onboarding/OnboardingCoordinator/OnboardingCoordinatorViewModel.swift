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

    init(
        startingProgress: OnboardingProgress,
        delegate: OnboardingCoordinatorDelegate?,
        analyticsManager: AnalyticsManager
    ) {
        self.delegate = delegate
        self.analyticsManager = analyticsManager

        if startingProgress == .slides {
            self.path = [.onboardingSlidesPath]
        }
    }

    func showOnboardingSlides() {
        path.append(.onboardingSlidesPath)
    }
}


// Extensions
extension OnboardingCoordinatorViewModel : QuizOnboardingViewModelDelegate {
    func didFinishQuiz() {
        delegate?.quizFlowDidFinish()
        showOnboardingSlides()
    }
}

extension OnboardingCoordinatorViewModel: SlideOnboardingViewModelDelegate {
    func didFinishSlideSequence() {
        print("SlideOnboardingView signaled completion.")
        delegate?.onboardingDidComplete()
    }
}
