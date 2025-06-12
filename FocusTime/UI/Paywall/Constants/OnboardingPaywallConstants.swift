//
//  OnboardingPaywallConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.05.2025.
//

import SwiftUI
import FocusTimeUI

extension OnboardingPaywallView {
    /// Organized and sorted ``OnboardingPaywallView`` constants.
    enum Constants {
        // MARK: - Feature Items
        /// Main selling points of the app.
        enum FeatureItems: String, CaseIterable, Identifiable {
            case unlimitedSessions = "Unlimited repeating sessions"
            case unlimitedApps     = "Unlimited number of blocking apps"
            case deepFocus         = "Deep Focus mode"
            case whiteNoise        = "White noise for better concentration"
            case priorityFeatures  = "Priority updates and new features"
            
            var id: String { rawValue }
            var systemImage: String {
                switch self {
                case .unlimitedSessions:
                    "arrow.trianglehead.2.clockwise.rotate.90"
                case .unlimitedApps:
                    "lock.circle"
                case .deepFocus:
                    "clock"
                case .whiteNoise:
                    "speaker.wave.2"
                case .priorityFeatures:
                    "icloud.and.arrow.up"
                }
            }
        }
        // MARK: - Gradient
        enum Gradient {
            // Colors
            static let glowColor: Color = .ftDarkBlue.opacity(0.5)
            static let secondColor: Color = .black
            // Radius
            static let startRadius: CGFloat = 1
            static let endRadius: CGFloat = 1500
        }
        // MARK: - Typography
        enum FontSize {
            static let navigationTitle: CGFloat = 34
        }
        
        // MARK: - Layout
        enum Padding {
            /// Padding around each feature in the list.
            static let featureList: CGFloat = 12
        }
        
        enum CornerRadius {
            /// Corner radius for primary container.
            static let card: CGFloat = 35
        }
        
        // MARK: - Strings
        enum Strings {
            // Purchase button states
            static let tryButtonTitle = "Try free and subscribe"
            static let pendingTitle = SharedPaywallConstants.Strings.pendingTitle
            static let subscribedTitle = SharedPaywallConstants.Strings.subscribedTitle
            
            static let featuresTitle = "Unlock All Features"
            
            // UI
            static let appName = SharedPaywallConstants.Strings.appName
            static let appSlogan = SharedPaywallConstants.Strings.appSlogan
            static let loadingTitle = SharedPaywallConstants.Strings.loadingTitle
            
            // Error
            static let errorHeader = SharedPaywallConstants.Strings.errorHeader
        }
        
    }
}
