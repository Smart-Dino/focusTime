//
//  SlideOnboardingConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 29.05.25.
//

import SwiftUI

extension SlideOnboardingView {
    enum Constants {
        enum Strings {
            static let title = String(localized: "slide_onboarding_main_title", table: "OnboardingLocalizable")
            static let nextButton = String(localized: "slide_onboarding_next_button", table: "OnboardingLocalizable")
            static let skipButton = String(localized: "slide_onboarding_skip_button", table: "OnboardingLocalizable")
            static let startButton = String(localized: "slide_onboarding_start_button", table: "OnboardingLocalizable")
            static let alertTitle = String(localized: "slide_onboarding_alert_title", table: "OnboardingLocalizable")
            static let alertMessage = String(localized: "slide_onboarding_alert_message", table: "OnboardingLocalizable")
            static let skipAnyway = String(localized: "slide_onboarding_alert_skip_anyway_button", table: "OnboardingLocalizable")
            static let goBack = String(localized: "slide_onboarding_alert_go_back_button", table: "OnboardingLocalizable")
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
        case .step1: String(localized: "slide_onboarding_step1_title", table: "OnboardingLocalizable")
        case .step2: String(localized: "slide_onboarding_step2_title", table: "OnboardingLocalizable")
        case .step3: String(localized: "slide_onboarding_step3_title", table: "OnboardingLocalizable")
        case .step4: String(localized: "slide_onboarding_step4_title", table: "OnboardingLocalizable")
        }
        
    }
    
    var subtitle2: String {
        switch self {
        case .step1: String(localized: "slide_onboarding_step1_description", table: "OnboardingLocalizable")
        case .step2: String(localized: "slide_onboarding_step2_description", table: "OnboardingLocalizable")
        case .step3: String(localized: "slide_onboarding_step3_description", table: "OnboardingLocalizable")
        case .step4: String(localized: "slide_onboarding_step4_description", table: "OnboardingLocalizable")
        }
    }
    
    var image: ImageResource {
        switch self {
        case .step1: .slideOnboardingImage1
        case .step2: .slideOnboardingImage2
        case .step3: .slideOnboardingImage1
        case .step4: .slideOnboardingImage2
        }
    }
    
    var isLast: Bool {
        self == Self.allCases.last
    }
}
