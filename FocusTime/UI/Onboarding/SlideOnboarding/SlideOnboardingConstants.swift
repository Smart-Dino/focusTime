//
//  SlideOnboardingConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 29.05.25.
//

import SwiftUI
import OnboardingKit

extension SlideOnboardingView {
    
    enum SlideOnboardingConstants {
        enum Layout {
            // General size constants
            static let buttonVerticalPadding: CGFloat = 13
            static let progressBarInactiveColorOpacity: CGFloat = 0.3
            static let onboardingMaskOpacity: CGFloat = 0.3
            
            // Constants for first slide blur
            static let blurRotationDegrees: Angle = .degrees(90)
            static let blurRadius: CGFloat = 30
            static let blurColorOpacity: CGFloat = 0.5
            static let blurWidth: CGFloat = 197
            static let blurHorisontalPadding: CGFloat = 150
            
            // Constants for first slide timer
            static let timerStackSpacing: CGFloat = 7
            static let timerBlockWidth: CGFloat = 77
            static let timerBlockHeight: CGFloat = 65
            static let timerBlockCornerRadius: CGFloat = 10
            static let timerStrokeWidth: CGFloat = 1
            static let shadowColorOpacity: CGFloat = 0.8
            static let shadowRadius: CGFloat = 2
            
            // Divider Constants
            static let dividerWidth: CGFloat = 70
            static let dividerHeight: CGFloat = 2
        }
        
        enum Strings {
            static let slideMainTitle: String = String(
                localized: "slide_onboarding_main_title",
                table: "OnboardingLocalizable"
            )
            static let nextButtonTitle: String = String(
                localized: "slide_onboarding_next_button",
                table: "OnboardingLocalizable"
            )
            static let startAppButtonTitle: String = String(
                localized: "slide_onboarding_start_button",
                table: "OnboardingLocalizable"
            )
            static let firstSlideTextTitle: String = String(
                localized: "slide_onboarding_focustime_title",
                table: "OnboardingLocalizable"
            )
        }
        
        enum Colors {
            static let progressBarActiveColor: Color = .blue
            static let skipButtonTextColor: Color = .blue
            static let timerBackgroundColor: Color = .ftOnboardingImageOverlayColor
            static let timerStrokeColor: Color = .ftSlidesTimerStrokeColor
        }
        
        enum Images {
            static let onboardingBackgroundImageName = "OnboardingSlideQuizBackground"
        }
    }
}

enum SlideOnboardingStep: CaseIterable {
    case step1, step2, step3, step4

    var slide: OnboardingSlide {
        switch self {
        case .step1:
            return OnboardingSlide(
                slideTitle: SlideOnboardingView.SlideOnboardingConstants.Strings.slideMainTitle,
                subtitle: String(
                    localized: "slide_onboarding_step1_title",
                    table: "OnboardingLocalizable"
                ),
                subtitleDescription: String(
                    localized: "slide_onboarding_step1_description",
                    table: "OnboardingLocalizable"
                ),
                customView: AnyView(FirstImageView()),
                imageAlignment: .center,
                imageContentMode: .fill
            )
        case .step2:
            return OnboardingSlide(
                slideTitle: SlideOnboardingView.SlideOnboardingConstants.Strings.slideMainTitle,
                subtitle: String(
                    localized: "slide_onboarding_step2_title",
                    table: "OnboardingLocalizable"
                ),
                subtitleDescription: String(
                    localized: "slide_onboarding_step2_description",
                    table: "OnboardingLocalizable"
                ),
                imageName: "OnboardingImages/TideBlocker",
                imageAlignment: .center,
                imageContentMode: .fill
            )
        case .step3:
            return OnboardingSlide(
                slideTitle: SlideOnboardingView.SlideOnboardingConstants.Strings.slideMainTitle,
                subtitle: String(
                    localized: "slide_onboarding_step3_title",
                    table: "OnboardingLocalizable"
                ),
                subtitleDescription: String(
                    localized: "slide_onboarding_step3_description",
                    table: "OnboardingLocalizable"
                ),
                imageName: "OnboardingImages/TideSchedule",
                imageAlignment: .bottom,
                imageContentMode: .fill
            )
        case .step4:
            return OnboardingSlide(
                slideTitle: SlideOnboardingView.SlideOnboardingConstants.Strings.slideMainTitle,
                subtitle: String(
                    localized: "slide_onboarding_step4_title",
                    table: "OnboardingLocalizable"
                ),
                subtitleDescription: String(
                    localized: "slide_onboarding_step4_description",
                    table: "OnboardingLocalizable"
                ),
                imageName: "OnboardingImages/OceanOfAchivement",
                imageAlignment: .bottom,
                imageContentMode: .fill
            )
        }
    }
}
