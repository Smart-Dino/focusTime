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
    struct State {
        var selection: Set<QuizOnboardingView.Constants.QuizOption> = []
        
        func isOptionSelected(_ option: QuizOnboardingView.Constants.QuizOption) -> Bool {
            selection.contains(option)
        }
    }
    
    private(set) var state: State
    weak var delegate: QuizOnboardingDelegate?
    var analyticsManager: AnalyticsManagerProtocol
    
    init(
        state: State = State(),
        delegate: QuizOnboardingDelegate?,
        analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()
    ) {
        self.state = state
        self.delegate = delegate
        self.analyticsManager = analyticsManager
    }
    
    func finishQuiz() {
        analyticsManager.logEvent(
            name: QuizOnboardingView.Constants.QuizOnboardingAnalyticsKeys.onboardingQuizFinished.rawValue,
            parameters: [
                QuizOnboardingView.Constants.QuizOnboardingAnalyticsParameterKeys.quizOptionsSelected: state.selection.map { $0.localizedString }.joined(separator: ",")
            ]
        )
        delegate?.didFinishQuiz(with: state.selection)
    }
    
    func toggleSelection(for option: QuizOnboardingView.Constants.QuizOption) {
        if state.selection.contains(option) {
            state.selection.remove(option)
        } else {
            state.selection.insert(option)
        }
        
        analyticsManager.logEvent(
            name: QuizOnboardingView.Constants.QuizOnboardingAnalyticsKeys.onboardingQuizOptionToggled.rawValue,
            parameters: [
                QuizOnboardingView.Constants.QuizOnboardingAnalyticsParameterKeys.quizOption: option.localizedString
            ]
        )
    }
}
