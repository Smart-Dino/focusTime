//
//  OnboardingPaywallConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import Foundation

/// Organized and sorted ``OnboardingPaywallView`` constants.
enum OnboardingPaywallConstants {
    // MARK: - Feature Items
    /// Main selling points of the app.
    enum FeatureItems: String, CaseIterable, Identifiable {
        case unlimitedSessions = "Unlimited repeating sessions"
        case unlimitedApps     = "Unlimited number of blocking apps"
        case deepFocus         = "Deep Focus mode"
        case whiteNoise        = "White noise for better concentration"
        case priorityFeatures  = "Priority updates and new features"
        
        var id: String { rawValue }
    }
    // MARK: - Typography
    enum FontSize {
        /// Title in navigation bar.
        static let navigationTitle: CGFloat = 34
    }
    
    // MARK: - Layout
    enum Padding {
        /// Padding around each feature in the list.
        static let featureList: CGFloat = 10
    }
    
    enum CornerRadius {
        /// Corner radius for primary container.
        static let card: CGFloat = 40
    }
    
    // MARK: - Strings
    enum Strings {
        /// Navigation title.
        static let navigationTitle = """
                       Get started with
                       a 3 day free trial
                       """
        /// Title text for the subscription trial button.
        static let tryButtonTitle = "Try free and subscribe."
        /// Title text for the button that dismisses the view.
        static let dismissButtonTitle = "Dismiss current screen."
    }
    
}
