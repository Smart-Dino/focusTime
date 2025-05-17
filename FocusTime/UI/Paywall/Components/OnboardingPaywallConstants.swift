//
//  OnboardingPaywallConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.05.2025.
//

import Foundation

/// Organized and sorted ``OnboardingPaywallView``-related constants.
enum OnboardingPaywall {
    // MARK: - Onboarding Typography
    enum FontSize {
        /// Title in navigation bar.
        static let navigationTitle: CGFloat = 34
    }
    
    // MARK: - Onboarding Layout
    enum Padding {
        /// Padding around each feature in the list.
        static let featureList: CGFloat = 10
    }
    
    enum CornerRadius {
        /// Corner radius for primary container.
        static let card: CGFloat = 40
    }
    
    // MARK: - Onboarding Strings
    enum Strings {
        /// Navigation title.
        static let navigationTitle = """
                   Get started with
                   a 3 day free trial
                   """
        /// Trial terms displayed above the try button.
        static let trialTerms = "3-day free trial, then $3 / month, cancel anytime"
        // Buttons
        static let tryButtonTitle = "Try free and subscribe."
        static let dismissButtonTitle = "Dismiss current screen."
    }
}
