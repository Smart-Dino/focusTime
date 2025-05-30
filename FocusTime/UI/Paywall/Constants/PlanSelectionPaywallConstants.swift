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
            static let navigationTitle = "Get DeepWave Pro"
            static let loadingMessage = SharedPaywallConstants.Strings.loadingMessage
            // Title text for the subscription trial button.
            static let startFreeTrial = "Start Free Trial"
            static let subscribeButtonTitle = SharedPaywallConstants.Strings.subscribeButtonTitle
            
            // Trial-related
            static let trialDescription = "Try Free For 3 days"
            static let noPaymentMessage = "No payment due now!"
            
            // Lifetime
            static let paidOnce = SharedPaywallConstants.Strings.paidOnce
            
            // Title text for the button that dismisses the view.
            static let dismissButtonTitle = SharedPaywallConstants.Strings.dismissButtonTitle
            
            // Error
            static let errorHeader = SharedPaywallConstants.Strings.errorHeader
        }
        
    }
}
