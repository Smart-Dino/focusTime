//
//  PaywallConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import Foundation

/// Organized and sorted paywall-related constants.
enum Paywall {
    /// Constants, shared across paywall views.
    private enum Shared {
        enum Strings {
            /// Trial terms displayed above the try button.
            static let trialTerms = "3-day free trial, then $3 / month, cancel anytime"
        }
    }
    
    /// Constants for the onboarding screen of the `PaywallView`.
    enum Onboarding {
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
            static let trialTerms = Paywall.Shared.Strings.trialTerms
            /// Title text for the subscription trial button.
            static let tryButtonTitle = "Try free and subscribe."
            /// Title text for the button that dismisses the view.
            static let dismissButtonTitle = "Dismiss current screen."
        }
    }
    
    enum Upgrade {
        // MARK: - FreeplanUpgrade Layout
        enum Spacings {
            static let offerView: CGFloat = 15
        }
        // MARK: - FreeplanUpgrade Strings
        enum Strings {
            /// Body message of the upgrade view.
            static var upgradeMessage: AttributedString {
                var string = AttributedString("Upgrade to have unlimited scheduled\nsessions with Pro version")
                if let range = string.range(of: "Pro version") {
                    string[range].font = .body.bold()
                }
                return string
            }
            /// Title of the view.
            static let title = "You're on a Free Plan"
            /// Trial terms displayed above the try button.
            static let trialTerms = Paywall.Shared.Strings.trialTerms
            /// Title text for the subscription trial button.
            static let tryButtonTitle = "Try For $0,00"
            static let viewPlansButton = "View All Plans"
        }
    }
    
    // Other paywall views...
}

