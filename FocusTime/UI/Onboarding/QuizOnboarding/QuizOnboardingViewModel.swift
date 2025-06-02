//
//  QuizOnboardingViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 15.05.25.
//

import Foundation
import Observation

@MainActor
@Observable
final class QuizOnboardingViewModel {
    typealias QuizOption = QuizOnboardingView.Constants.QuizOption

    struct State {
        var selectionStates: Set<QuizOption> = []
    }

    var state = State()
    private let analyticsManager: AnalyticsManaging
    private var onNextCallback: () -> Void

    init(
        analyticsManager: AnalyticsManaging = AppAnalytics.shared,
        onNext: @escaping () -> Void = {}
    ) {
        self.analyticsManager = analyticsManager
        self.onNextCallback = onNext
        self.analyticsManager.log(event: .screenView(screenName: "QuizOnboardingView"))
    }

    func toggleSelection(for option: QuizOption) {
        let isCurrentlySelected = state.selectionStates.contains(option)
        if isCurrentlySelected {
            state.selectionStates.remove(option)
        } else {
            state.selectionStates.insert(option)
        }
        analyticsManager.log(event: .quizOptionToggled(option: option.rawValue, isSelected: !isCurrentlySelected))
    }

    func isOptionSelected(_ option: QuizOption) -> Bool {
        state.selectionStates.contains(option)
    }

    func nextButtonTapped() {
        analyticsManager.log(event: .quizNextButtonTapped)
        onNextCallback()
    }
}
