//
//  PlanSelectionPaywallConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.05.2025.
//

import Foundation

/// Organized and sorted ``PlanSelectionPaywallView`` constants.
enum PlanSelectionPaywallConstants {
    // MARK: - Typography
    enum FontSize { }
    
    // MARK: - Layout
    enum Padding {
        /// Spacing between the subscription list's offerings.
        static let featuresSpacing: CGFloat = 20
    }
    
    enum CornerRadius { }
    
    // MARK: - Strings
    enum Strings {
        static let navigationTitle = "Get DeepWave Pro"
        static let loadingMessage = "Loading..."
        /// Title text for the subscription trial button.
        static let startFreeTrial = "Start Free Trial"
        static let subscribeButtonTitle = "Subscribe"
        
        /// Trial-related
        static let trialDescription = "Try Free For 3 days"
        static let noPaymentMessage = "No payment due now!"
        
        /// Lifetime
        static let paidOnce = "Paid once"
        
        /// Title text for the button that dismisses the view.
        static let dismissButtonTitle = "Dismiss current screen."
    }
    
}

