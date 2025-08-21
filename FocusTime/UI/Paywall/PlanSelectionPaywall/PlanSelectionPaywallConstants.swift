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
        // MARK: - Layout
        enum Padding {
            /// Spacing between the subscription list's offerings.
            static let featuresSpacing: CGFloat = 20
        }
        
        // MARK: - Strings
        enum Strings {
            static let navigationTitle = String(localized: "plan_selection_paywall_navigation_title", table: "PaywallLocalizable")
            static let loadingTitle = SharedConstants.Strings.loadingTitle
            // Title text for the subscription trial button.
            static let startFreeTrial = String(localized: "plan_selection_paywall_start_free_trial_button", table: "PaywallLocalizable")
            static let subscribeButtonTitle = SharedConstants.Strings.subscribeTitle
            static let subscribedTitle = SharedConstants.Strings.subscribedTitle
            static let purchasedTitle = SharedConstants.Strings.purchasedTitle
            
            static let noPaymentMessage = String(localized: "plan_selection_paywall_no_payment_message", table: "PaywallLocalizable")
            
            // Lifetime
            static let paidOnce = SharedConstants.Strings.paidOnce
            
            // Error
            static let errorHeader = SharedConstants.Strings.errorHeader
        }
        
    }
}
