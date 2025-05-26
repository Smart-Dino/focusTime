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

    enum SelectionState {
        case selected
        case unselected
    }

    struct QuizOption: Identifiable, Equatable {
        let id = UUID()
        let title: String
    }

    struct State {
        var options: [QuizOption] = [
            QuizOption(title: "📩 Notifications and messages"),
            QuizOption(title: "📱 Social media"),
            QuizOption(title: "💻 Work distractions"),
            QuizOption(title: "📋 Lack of structure"),
            QuizOption(title: "🧘 Mental fatigue")
        ]
        
        var selectionStates: [UUID: SelectionState] = [:]
    }

    var state = State()

    func toggleSelection(for option: QuizOption) {
        let current = state.selectionStates[option.id] ?? .unselected
        state.selectionStates[option.id] = (current == .selected) ? .unselected : .selected
    }

    func isOptionSelected(_ option: QuizOption) -> Bool {
        state.selectionStates[option.id] == .selected
    }
}
