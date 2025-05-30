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
        // Potentially add other state properties if needed
    }

    var state = State()
    private let analyticsManager: AnalyticsManaging
    private var onNextCallback: () -> Void // Callback to trigger navigation

    init(
        analyticsManager: AnalyticsManaging = AppAnalytics.shared, // Default for previews/simplicity
        onNext: @escaping () -> Void = {} // Default empty callback for previews
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
        // Any other logic before navigating (e.g., save quiz choices)
        onNextCallback() // Trigger navigation via the coordinator
    }
}
