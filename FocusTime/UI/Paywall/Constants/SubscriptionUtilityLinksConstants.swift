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
            static let terms = "Terms"
            static let privacy = "Privacy"
            static let restorePurchases = "Restore purchases"
            
            // Alert
            static let errorHeader = "An error occured"
            
            // Other UI
            static let separatorDot = "•"
        }
    }
}
