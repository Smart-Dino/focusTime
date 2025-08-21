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
        enum FeatureItems: CaseIterable, Identifiable {
            case unlimitedSessions
            case unlimitedApps
            case deepFocus
            case whiteNoise
            case priorityFeatures
            
            var id: Self { self }
            
            var title: String {
                switch self {
                case .unlimitedSessions:
                    String(localized: "onboarding_paywall_feature_unlimited_sessions", table: "PaywallLocalizable")
                case .unlimitedApps:
                    String(localized: "onboarding_paywall_feature_unlimited_apps", table: "PaywallLocalizable")
                case .deepFocus:
                    String(localized: "onboarding_paywall_feature_deep_focus", table: "PaywallLocalizable")
                case .whiteNoise:
                    String(localized: "onboarding_paywall_feature_white_noise", table: "PaywallLocalizable")
                case .priorityFeatures:
                    String(localized: "onboarding_paywall_feature_priority_features", table: "PaywallLocalizable")
                }
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
            static let navigationTitle = SharedConstants.Fonts.navigationTitle
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
            static let subscribeButtonTitle = SharedConstants.Strings.subscribeTitle
            static let pendingTitle = SharedConstants.Strings.pendingTitle
            static let subscribedTitle = SharedConstants.Strings.subscribedTitle
            
            static let featuresTitle = String(localized: "onboarding_paywall_features_title", table: "PaywallLocalizable")
            
            // UI
            static let appName = SharedConstants.Strings.appName
            static let appSlogan = SharedConstants.Strings.appSlogan
            static let loadingTitle = SharedConstants.Strings.loadingTitle
            
            // Error
            static let errorHeader = SharedConstants.Strings.errorHeader
        }
        
    }
}

