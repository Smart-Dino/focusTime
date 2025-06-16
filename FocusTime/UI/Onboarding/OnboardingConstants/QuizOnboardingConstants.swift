//
//  QuizOnboardingConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 26.05.25.
//

import Foundation

extension QuizOnboardingView {
    enum Constants {
        
        
        enum Layout {
            static let titleSpacing: CGFloat = 11
            static let bottomPadding: CGFloat = 40
            static let quizSpacing: CGFloat = 42
            static let toggleBarSpacing: CGFloat = 1
        }
        
        enum Strings {
            static let title = "What challenges your focus most often?"
            static let subtitle = "Add one or more options that work for you."
            static let nextButton = "Next"
        }
        
        enum QuizOption: String, CaseIterable, Identifiable, Hashable {
            case notifications = "📩 Notifications and messages"
            case socialMedia = "📱 Social media"
            case workDistractions = "💻 Work distractions"
            case lackOfStructure = "📋 Lack of structure"
            case mentalFatigue = "🧘 Mental fatigue"
            
            var id: String { rawValue }
        }
    }
}
