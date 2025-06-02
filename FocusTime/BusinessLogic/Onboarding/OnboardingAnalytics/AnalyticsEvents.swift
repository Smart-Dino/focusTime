//
//  AnalyticsEvents.swift
//  FocusTime
//
//  Created by Keto Nioradze on 30.05.25.
//

// This enum provides a type-safe way to represent events and their associated parameters.

import Foundation

enum AnalyticsEvent: Sendable {
    case screenView(screenName: String)
    case quizOptionToggled(option: String, isSelected: Bool)
    case quizNextButtonTapped
    case onboardingSlideViewed(slideName: String, slideIndex: Int)
    case onboardingNextSlideTapped(fromSlideName: String, fromSlideIndex: Int)
    case onboardingSkipInitiated(fromSlideName: String, fromSlideIndex: Int)
    case onboardingSkipConfirmed(fromSlideName: String, fromSlideIndex: Int)
    case onboardingCompleted(lastSlideName: String)

    var name: String {
        switch self {
        case .screenView: return "screen_view"
        case .quizOptionToggled: return "quiz_option_toggled"
        case .quizNextButtonTapped: return "quiz_next_button_tapped"
        case .onboardingSlideViewed: return "onboarding_slide_viewed"
        case .onboardingNextSlideTapped: return "onboarding_next_slide_tapped"
        case .onboardingSkipInitiated: return "onboarding_skip_initiated"
        case .onboardingSkipConfirmed: return "onboarding_skip_confirmed"
        case .onboardingCompleted: return "onboarding_completed"
        }
    }

    var parameters: [String: any Sendable]? {
        switch self {
        case .screenView(let screenName):
            return ["screen_name": screenName]
        case .quizOptionToggled(let option, let isSelected):
            return ["option_raw_value": option, "selected": isSelected]
        case .quizNextButtonTapped:
            return nil
        case .onboardingSlideViewed(let slideName, let slideIndex):
            return ["slide_name": slideName, "slide_index": slideIndex]
        case .onboardingNextSlideTapped(let fromSlideName, let fromSlideIndex):
            return ["from_slide_name": fromSlideName, "from_slide_index": fromSlideIndex]
        case .onboardingSkipInitiated(let fromSlideName, let fromSlideIndex):
            return ["from_slide_name": fromSlideName, "from_slide_index": fromSlideIndex]
        case .onboardingSkipConfirmed(let fromSlideName, let fromSlideIndex):
            return ["from_slide_name": fromSlideName, "from_slide_index": fromSlideIndex]
        case .onboardingCompleted(let lastSlideName):
            return ["last_slide_name": lastSlideName]
        }
    }
}
