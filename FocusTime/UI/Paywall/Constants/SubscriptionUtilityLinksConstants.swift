//
//  SubscriptionUtilityLinksConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 18.05.2025.
//

import Foundation

extension SubscriptionUtilityLinksView {
    /// Constants namespace for ``SubscriptionUtilityLinksView``.
    enum Constants {
        // MARK: - UI Constants
        enum FontSize {
            static let separatorDotFontSize: CGFloat = 20
        }
        enum Spacings {
            static let horizontalSpacing: CGFloat = 20
        }
        enum Strings {
            // MARK: - UI Strings
            
            // Button titles
            static let terms = String(localized: "Terms", table: "PaywallLocalizable")
            static let privacy = String(localized: "Privacy", table: "PaywallLocalizable")
            static let restorePurchases = String(localized: "Restore purchases", table: "PaywallLocalizable")
            
            // Alert
            static let errorHeader = String(localized: "An error occurred", table: "PaywallLocalizable")
            
            // Other UI
            static let separatorDot = "•"
        }
    }
}
