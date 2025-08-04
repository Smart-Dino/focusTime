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
            static let title = String(localized: "quiz_onboarding_title", table: "OnboardingLocalizable")
            static let subtitle = String(localized: "quiz_onboarding_subtitle", table: "OnboardingLocalizable")
            static let nextButton = String(localized: "quiz_onboarding_next_button", table: "OnboardingLocalizable")
        }
        
        enum QuizOption: String, CaseIterable, Identifiable, Hashable {
            case notifications = "quiz_onboarding_option_notifications"
            case socialMedia = "quiz_onboarding_option_social_media"
            case workDistractions = "quiz_onboarding_option_work_distractions"
            case lackOfStructure = "quiz_onboarding_option_lack_of_structure"
            case mentalFatigue = "quiz_onboarding_option_mental_fatigue"
            
            var id: String { rawValue }
            
            var localizedString: String {
                String(localized: String.LocalizationValue(rawValue), table: "OnboardingLocalizable")
            }
        }
    }
}
