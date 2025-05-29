//
//  QuizOnboardingViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 15.05.25.
//

import Foundation
import Observation

/// Uses Swift’s new `@Observable` macro for reactive data binding (iOS 17+).

@MainActor
@Observable
final class QuizOnboardingViewModel {
    
    typealias QuizOption = QuizOnboardingView.Constants.QuizOption
    
    struct State {
        var selectionStates: Set<QuizOption> = []
    }
    
    var state = State()
    
    func toggleSelection(for option: QuizOption) {
        if state.selectionStates.contains(option) {
            state.selectionStates.remove(option)
        } else {
            state.selectionStates.insert(option)
        }
    }
    
    func isOptionSelected(_ option: QuizOption) -> Bool {
        state.selectionStates.contains(option)
    }
}
