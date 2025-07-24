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
        }
        
        enum Strings {
            static let title = String(localized: "What challenges your focus most often?", table: "OnboardingLocalizable")
            static let subtitle = String(localized: "Add one or more options that work for you.", table: "OnboardingLocalizable")
            static let nextButton = String(localized: "Next", table: "OnboardingLocalizable")
        }
        
        enum QuizOption: String, CaseIterable, Identifiable, Hashable {
            case notifications = "📩 Notifications and messages"
            case socialMedia = "📱 Social media"
            case workDistractions = "💻 Work distractions"
            case lackOfStructure = "📋 Lack of structure"
            case mentalFatigue = "🧘 Mental fatigue"
            
            var id: String { rawValue }
            
            var localizedString: String {
                String(localized: String.LocalizationValue(rawValue), table: "OnboardingLocalizable")
            }
        }
    }
}
