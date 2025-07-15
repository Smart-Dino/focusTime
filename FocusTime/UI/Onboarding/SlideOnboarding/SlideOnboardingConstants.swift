//
//  SlideOnboardingConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 29.05.25.
//

import Foundation

extension SlideOnboardingView {
    enum Constants {
        enum Strings {
            static let title = String(localized: "RIDE THE WAVES OF PRODUCTIVITY", table: "OnboardingLocalizable")
            static let nextButton = String(localized: "Next", table: "OnboardingLocalizable")
            static let skipButton = String(localized: "Skip", table: "OnboardingLocalizable")
            static let startButton = String(localized: "Start Focusing", table: "OnboardingLocalizable")
            static let alertTitle = String(localized: "Before you go...", table: "OnboardingLocalizable")
            static let alertMessage = String(localized: "Are you sure you want to skip the onboarding?", table: "OnboardingLocalizable")
            static let skipAnyway = String(localized: "Skip anyway", table: "OnboardingLocalizable")
            static let goBack = String(localized: "Go back", table: "OnboardingLocalizable")
        }

        enum Layout {
            static let topPadding: CGFloat = 20
            static let subtitleSectionHeight: CGFloat = 152
            static let buttonSectionHeight: CGFloat = 78
            static let buttonSpacing: CGFloat = 16
            static let progressBarTopPadding: CGFloat = 31
        }
    }
}


enum SlideOnboardingStep: CaseIterable {
    case step1, step2, step3, step4

    var subtitle1: String {
        switch self {
        case .step1: return String(localized: "Wave Cycles", table: "OnboardingLocalizable")
        case .step2: return String(localized: "Tide Blocker", table: "OnboardingLocalizable")
        case .step3: return String(localized: "Current Tracker", table: "OnboardingLocalizable")
        case .step4: return String(localized: "Ocean of Achievement", table: "OnboardingLocalizable")
        }
        
    }

    var subtitle2: String {
        switch self {
        case .step1:
             return String(localized: "25-minute focus sessions followed by 5-minute recovery breaks, modeled after the natural rhythm of ocean waves", table: "OnboardingLocalizable")
         case .step2:
             return String(localized: "Automatically silences notifications and blocks distracting apps during your focus sessions, keeping your mental waters clear", table: "OnboardingLocalizable")
         case .step3:
             return String(localized: "Visualize your productivity patterns with intuitive analytics that show your focus trends and improvements over time", table: "OnboardingLocalizable")
         case .step4:
             return String(localized: "Collect unique marine-themed awards as you develop stronger focus habits and reach new productivity depths", table: "OnboardingLocalizable")
         }
    }
    
    var imageName: String {
        switch self {
        case .step1: return "SlideOnboardingImage1"
        case .step2: return "SlideOnboardingImage2"
        case .step3: return "SlideOnboardingImage1"
        case .step4: return "SlideOnboardingImage2"
        }
    }

    var isLast: Bool {
        self == Self.allCases.last
    }
}
