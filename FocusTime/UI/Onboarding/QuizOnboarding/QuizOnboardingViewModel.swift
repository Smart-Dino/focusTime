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
        var selectionStates: Set<QuizOnboardingView.Constants.QuizOption> = []
    }
    
    private(set) var state = State()
    
    func toggleSelection(for option: QuizOnboardingView.Constants.QuizOption) {
        if state.selectionStates.contains(option) {
            state.selectionStates.remove(option)
        } else {
            state.selectionStates.insert(option)
        }
    }
    
    func isOptionSelected(_ option: QuizOnboardingView.Constants.QuizOption) -> Bool {
        state.selectionStates.contains(option)
    }
}
