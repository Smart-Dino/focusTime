//
//  QuizOnboardingViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 15.05.25.
//

import Foundation
import Observation

/// ViewModel for managing quiz onboarding logic and state.
/// This ViewModel is designed to be used with SwiftUI views for quiz onboarding.
/// It holds the available quiz options and encapsulates the onboarding state.

/// Uses Swift’s new `@Observable` macro for reactive data binding (iOS 17+).

@MainActor
@Observable
final class QuizOnboardingViewModel {
    
    // MARK: - Nested Types
        
    /// Represents a single quiz option.
    /// Conforms to `Identifiable` so it can be used in SwiftUI lists.
    struct QuizOption: Identifiable {
        let id = UUID()
        let title: String
        var isSelected: Bool
    }
    
    // MARK: - State
        
    /// Encapsulates the UI state for the quiz onboarding screen.
    /// Contains all mutable data the view will observe.
    struct State {
        /// List of quiz options available for selection.
        var options: [QuizOption] = [
            QuizOption(title: "📩 Notifications and messages", isSelected: false),
            QuizOption(title: "📱 Social media", isSelected: false),
            QuizOption(title: "💻 Work distractions", isSelected: false),
            QuizOption(title: "📋 Lack of structure", isSelected: false),
            QuizOption(title: "🧘 Mental fatigue", isSelected: false)
        ]
    }
    /// The current state of the onboarding quiz.
    /// Read-only outside the ViewModel to maintain encapsulation.
    var state = State()
}
