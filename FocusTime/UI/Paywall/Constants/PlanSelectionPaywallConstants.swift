//
//  PlanSelectionPaywallConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.05.2025.
//

import Foundation

extension PlanSelectionPaywallView {
    /// Organized and sorted ``PlanSelectionPaywallView`` constants.
    enum Constants {
        // MARK: - Typography
        enum FontSize { }
        
        // MARK: - Layout
        enum Padding {
            /// Spacing between the subscription list's offerings.
            static let featuresSpacing: CGFloat = 20
        }
        
        // MARK: - Strings
        enum Strings {
            static let navigationTitle = String(localized: "Get DeepWave Pro", table: "PaywallLocalizable")
            static let loadingTitle = SharedPaywallConstants.Strings.loadingTitle
            // Title text for the subscription trial button.
            static let startFreeTrial = String(localized: "Start Free Trial", table: "PaywallLocalizable")
            static let subscribeButtonTitle = SharedPaywallConstants.Strings.subscribeButtonTitle
            static let subscribedTitle = SharedPaywallConstants.Strings.subscribedTitle
            static let purchasedTitle = SharedPaywallConstants.Strings.purchasedTitle
            
            // Trial-related
            static let trialDescription = String(localized: "Try Free For 3 days", table: "PaywallLocalizable")
            static let noPaymentMessage = String(localized: "No payment due now!", table: "PaywallLocalizable")
            
            // Lifetime
            static let paidOnce = SharedConstants.Strings.paidOnce
            
            // Title text for the button that dismisses the view.
            static let dismissButtonTitle = SharedConstants.Strings.dismissButtonTitle
            
            // Error
            static let errorHeader = SharedPaywallConstants.Strings.errorHeader
            static let defaultTrialError = String(localized: "Unable to load trial information.", table: "PaywallLocalizable")
            static let subscribeButtonTerms  = String(localized: "Subscription automatically renews unless canceled. You can cancel anytime.", table: "PaywallLocalizable")
        }
        
    }
}
