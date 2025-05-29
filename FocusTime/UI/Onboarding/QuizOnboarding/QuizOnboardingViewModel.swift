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
        
    var selectionStates: Set<QuizOption> = []
    
    func toggleSelection(for option: QuizOption) {
        if selectionStates.contains(option) {
            selectionStates.remove(option)
        } else {
            selectionStates.insert(option)
        }
    }

    func isOptionSelected(_ option: QuizOption) -> Bool {
        selectionStates.contains(option)
    }
}
