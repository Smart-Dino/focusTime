//
//  OnboardingProgress.swift
//  FocusTime
//
//  Created by Keto Nioradze on 16.06.25.
//

import Foundation

/// Represents the user's progress through the onboarding flow.
/// Using a String raw value makes it easy to save to UserDefaults.
enum OnboardingProgress: String {
    case quiz
    case slides
    case completed
}
