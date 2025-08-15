//
//  QuizOnboardingConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 26.05.25.
//

import SwiftUI

extension QuizOnboardingView {
    enum Constants {
        enum Images {
            static let backgroundImage = ImageResource.OnboardingImages.onboardingQuizBackground
            static let backgroundImageOpacity = 0.7
        }
        
        enum Layout {
            static let titleSpacing: CGFloat = 11
            static let quizSpacing: CGFloat = 42
        }
        
        enum Strings {
            static let title = String(localized: "quiz_onboarding_title", table: "OnboardingLocalizable")
            static let subtitle = String(localized: "quiz_onboarding_subtitle", table: "OnboardingLocalizable")
            static let nextButton = String(localized: "quiz_onboarding_next_button", table: "OnboardingLocalizable")
        }
        
        enum QuizOption: CaseIterable, Identifiable, Hashable {
            case notifications
            case socialMedia
            case workDistractions
            case lackOfStructure
            case mentalFatigue
            
            var id: Self { self }
            
            var localizedString: String {
                switch self {
                case .notifications:
                    String(localized: "quiz_onboarding_option_notifications", table: "OnboardingLocalizable")
                case .socialMedia:
                    String(localized: "quiz_onboarding_option_social_media", table: "OnboardingLocalizable")
                case .workDistractions:
                    String(localized: "quiz_onboarding_option_work_distractions", table: "OnboardingLocalizable")
                case .lackOfStructure:
                    String(localized: "quiz_onboarding_option_lack_of_structure", table: "OnboardingLocalizable")
                case .mentalFatigue:
                    String(localized: "quiz_onboarding_option_mental_fatigue", table: "OnboardingLocalizable")
                }
            }
        }
    }
}
