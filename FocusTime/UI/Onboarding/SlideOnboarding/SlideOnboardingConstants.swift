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
        }
    }
}

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

