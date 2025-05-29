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
            static let title = "RIDE THE WAVES OF PRODUCTIVITY"
            static let nextButton = "Next"
            static let skipButton = "Skip"
            static let startButton = "Start Focusing"
            static let alertTitle = "Before you go..."
            static let alertMessage = "Are you sure you want to skip the onboarding?"
            static let skipAnyway = "Skip anyway"
            static let goBack = "Go back"
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
        case .step1: return "Wave Cycles"
        case .step2: return "Tide Blocker"
        case .step3: return "Current Tracker"
        case .step4: return "Ocean of Achievement"
        }
    }

    var subtitle2: String {
        switch self {
        case .step1:
            return "25-minute focus sessions followed by 5-minute recovery breaks, modeled after the natural rhythm of ocean waves"
        case .step2:
            return "Automatically silences notifications and blocks distracting apps during your focus sessions, keeping your mental waters clear"
        case .step3:
            return "Visualize your productivity patterns with intuitive analytics that show your focus trends and improvements over time"
        case .step4:
            return "Collect unique marine-themed awards as you develop stronger focus habits and reach new productivity depths"
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
