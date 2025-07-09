//
//  SlideOnboardingConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 29.05.25.
//

import Foundation
import OnboardingKit

extension SlideOnboardingView {
    enum SlideOnboardingConstants {
        enum Layout{
            static let buttonVerticalPadding: CGFloat = 13
            static let progressBarInactiveColorOpacity: CGFloat = 0.3
            static let textContainerHeight: CGFloat = 100
            static let OnboardingMaskOpacity: CGFloat = 0.3
        }
    }
}

enum SlideOnboardingStep: CaseIterable {
    case step1, step2, step3, step4

    var slide: OnboardingSlide {
        switch self {
        case .step1:
            return OnboardingSlide(
                slideTitle: String(localized: "RIDE THE WAVES OF PRODUCTIVITY", table: "OnboardingLocalizable"),
                subtitle: String(localized: "Wave Cycles", table: "OnboardingLocalizable"),
                subtitleDescription: String(localized: "25-minute focus sessions followed by 5-minute recovery breaks, modeled after the natural rhythm of ocean waves", table: "OnboardingLocalizable"),
                imageName: "SlideOnboardingImage1"
            )
        case .step2:
            return OnboardingSlide(
                slideTitle: String(localized: "RIDE THE WAVES OF PRODUCTIVITY", table: "OnboardingLocalizable"),
                subtitle: String(localized: "Tide Blocker", table: "OnboardingLocalizable"),
                subtitleDescription: String(localized: "Automatically silences notifications and blocks distracting apps during your focus sessions, keeping your mental waters clear", table: "OnboardingLocalizable"),
                imageName: "SlideOnboardingImage2"
            )
        case .step3:
            return OnboardingSlide(
                slideTitle: String(localized: "RIDE THE WAVES OF PRODUCTIVITY", table: "OnboardingLocalizable"),
                subtitle: String(localized: "Current Tracker", table: "OnboardingLocalizable"),
                subtitleDescription: String(localized: "Visualize your productivity patterns with intuitive analytics that show your focus trends and improvements over time", table: "OnboardingLocalizable"),
                imageName: "SlideOnboardingImage1"
            )
        case .step4:
            return OnboardingSlide(
                slideTitle: String(localized: "RIDE THE WAVES OF PRODUCTIVITY", table: "OnboardingLocalizable"),
                subtitle: String(localized: "Ocean of Achievement", table: "OnboardingLocalizable"),
                subtitleDescription: String(localized: "Collect unique marine-themed awards as you develop stronger focus habits and reach new productivity depths", table: "OnboardingLocalizable"),
                imageName: "SlideOnboardingImage2"
            )
        }
    }
}

