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
            static let navigationTitle = String(localized: "plan_selection_paywall_navigation_title", table: "PaywallLocalizable")
            static let loadingTitle = SharedPaywallConstants.Strings.loadingTitle
            // Title text for the subscription trial button.
            static let startFreeTrial = String(localized: "plan_selection_paywall_start_free_trial_button", table: "PaywallLocalizable")
            static let subscribeButtonTitle = SharedPaywallConstants.Strings.subscribeButtonTitle
            static let subscribedTitle = SharedPaywallConstants.Strings.subscribedTitle
            static let purchasedTitle = SharedPaywallConstants.Strings.purchasedTitle
            
            // Trial-related
            static let trialDescription = String(localized: "plan_selection_paywall_trial_description_3_days", table: "PaywallLocalizable")
            static let noPaymentMessage = String(localized: "plan_selection_paywall_no_payment_message", table: "PaywallLocalizable")
            
            // Lifetime
            static let paidOnce = SharedPaywallConstants.Strings.paidOnce
            
            // Title text for the button that dismisses the view.
            static let dismissButtonTitle = SharedPaywallConstants.Strings.dismissButtonTitle
            
            // Error
            static let errorHeader = SharedPaywallConstants.Strings.errorHeader
            static let defaultTrialError = String(localized: "plan_selection_paywall_default_trial_error", table: "PaywallLocalizable")
            static let subscribeButtonTerms  = String(localized: "plan_selection_paywall_subscription_terms", table: "PaywallLocalizable")
        }
        
    }
}
