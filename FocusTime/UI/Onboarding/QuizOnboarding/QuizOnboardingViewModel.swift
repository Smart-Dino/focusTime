//
//  QuizOnboardingViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 15.05.25.
//

import Foundation

// MARK: - ViewModel
/// ViewModel for managing quiz onboarding logic and state.

/// Represents a selectable quiz option with a unique ID and a display title.
struct QuizOption: Identifiable {
    let id = UUID()
    let title: String
}

/// Currently holds a list of predefined quiz options for display.
class QuizOnboardingViewModel: ObservableObject {
    
    /// Published list of quiz options to be shown in the UI.
    /// This can be expanded or modified in the future to support dynamic content.
    @Published var options: [QuizOption] = [
        QuizOption(title: "📩 Notifications and messages"),
        QuizOption(title: "📱 Social media"),
        QuizOption(title: "💻 Work distractions"),
        QuizOption(title: "📋 Lack of structure"),
        QuizOption(title: "🧘 Mental fatigue")
    ]
}
