//
//  SlideOnboardingConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 29.05.25.
//

import SwiftUI
<<<<<<< HEAD
import OnboardingKit

extension SlideOnboardingView {
    
    enum SlideOnboardingConstants {
        enum Layout {
            static let buttonVerticalPadding: CGFloat = 13
            static let progressBarInactiveColorOpacity: CGFloat = 0.3
            static let onboardingMaskOpacity: CGFloat = 0.3
        }
        
        enum Strings {
            static let slideSubtitle: String = String(
                localized: "RIDE THE WAVES OF PRODUCTIVITY",
                table: "OnboardingLocalizable"
            )
            static let nextButtonTitle: String = String(
                localized: "Next",
                table: "OnboardingLocalizable"
            )
            static let startAppButtonTitle: String = String(
                localized: "Start Focusing",
                table: "OnboardingLocalizable"
            )
        }
        
        enum Colors {
            static let progressBarActiveColor: Color = .blue
            static let skipButtonTextColor: Color = .blue
        }
        
        enum Images {
            static let onboardingBackgroundImageName = "OnboardingSlideQuizBackground"
=======

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
>>>>>>> main
        }
    }
}

<<<<<<< HEAD
enum SlideOnboardingStep: CaseIterable {
    case step1, step2, step3, step4

    var slide: OnboardingSlide {
        switch self {
        case .step1:
            return OnboardingSlide(
                slideTitle: SlideOnboardingView.SlideOnboardingConstants.Strings.slideSubtitle,
                subtitle: String(
                    localized: "Wave Cycles",
                    table: "OnboardingLocalizable"
                ),
                subtitleDescription: String(
                    localized: "25-minute focus sessions followed by 5-minute recovery breaks, modeled after the natural rhythm of ocean waves",
                    table: "OnboardingLocalizable"
                ),
                imageName: "SlideOnboardingImage1"
            )
        case .step2:
            return OnboardingSlide(
                slideTitle: SlideOnboardingView.SlideOnboardingConstants.Strings.slideSubtitle,
                subtitle: String(
                    localized: "Tide Blocker",
                    table: "OnboardingLocalizable"
                ),
                subtitleDescription: String(
                    localized: "Automatically silences notifications and blocks distracting apps during your focus sessions, keeping your mental waters clear",
                    table: "OnboardingLocalizable"
                ),
                imageName: "TideBlocker"
            )
        case .step3:
            return OnboardingSlide(
                slideTitle: SlideOnboardingView.SlideOnboardingConstants.Strings.slideSubtitle,
                subtitle: String(
                    localized: "Tide Schedule",
                    table: "OnboardingLocalizable"
                ),
                subtitleDescription: String(
                    localized: "Set up automatic focus sessions that activate at predetermined times, blocking distracting apps like ocean",
                    table: "OnboardingLocalizable"
                ),
                imageName: "TideSchedule"
            )
        case .step4:
            return OnboardingSlide(
                slideTitle: SlideOnboardingView.SlideOnboardingConstants.Strings.slideSubtitle,
                subtitle: String(
                    localized: "Ocean of Achievement",
                    table: "OnboardingLocalizable"
                ),
                subtitleDescription: String(
                    localized: "Collect unique marine-themed awards as you develop stronger focus habits and reach new productivity depths",
                    table: "OnboardingLocalizable"
                ),
                imageName: "OceanOfAchivement"
            )
        }
    }
}

=======

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
>>>>>>> main
