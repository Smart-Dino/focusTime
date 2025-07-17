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
            case unlimitedSessions = "onboarding_paywall_feature_unlimited_sessions"
            case unlimitedApps     = "onboarding_paywall_feature_unlimited_apps"
            case deepFocus         = "onboarding_paywall_feature_deep_focus"
            case whiteNoise        = "onboarding_paywall_feature_white_noise"
            case priorityFeatures  = "onboarding_paywall_feature_priority_features"
            
            var id: String { rawValue }
            var title: String {
                String(localized: String.LocalizationValue(rawValue), table: "PaywallLocalizable")
            }
            
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
        enum Fonts {
            static let navigationTitle = SharedPaywallConstants.Fonts.navigationTitle
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
            static let tryButtonTitle = String(localized: "onboarding_paywall_try_free_and_subscribe_button", table: "PaywallLocalizable")
            static let pendingTitle = SharedPaywallConstants.Strings.pendingTitle
            static let subscribedTitle = SharedPaywallConstants.Strings.subscribedTitle
            
            static let featuresTitle = String(localized: "onboarding_paywall_features_title", table: "PaywallLocalizable")
            
            // UI
            static let appName = SharedPaywallConstants.Strings.appName
            static let appSlogan = SharedPaywallConstants.Strings.appSlogan
            static let loadingTitle = SharedPaywallConstants.Strings.loadingTitle
            
            // Error
            static let errorHeader = SharedPaywallConstants.Strings.errorHeader
        }
        
    }
}
