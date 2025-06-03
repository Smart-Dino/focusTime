//
//  FreePlanUpgradeConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.05.2025.
//

import Foundation

extension FreePlanUpgradeView {
    /// Organized and sorted ``FreePlanUpgradeView``-related constants.
    enum Constants {
        // MARK: - FreeplanUpgrade Layout
        enum Spacings {
            static let offerView: CGFloat = 15
        }
        // MARK: - FreeplanUpgrade Strings
        enum Strings {
            /// Body message of the upgrade view.
            static var upgradeMessage: AttributedString {
                var string = AttributedString("Upgrade to have unlimited scheduled\nsessions with Pro version")
                if let range = string.range(of: "Pro version") {
                    string[range].font = .body.bold()
                }
                return string
            }
            
            // Title of the view.
            static let title = "You're on a Free Plan"
            
            // Loading state
            static let loadingMessage = SharedPaywallConstants.Strings.loadingMessage
            
            // Purchase button states
            static let tryButtonTitle = "Try For $0,00"
            static let pendingMessage = SharedPaywallConstants.Strings.pendingMessage
            static let subscribedMessage = SharedPaywallConstants.Strings.subscribedMessage
            
            // Other buttons
            static let viewPlansButton = SharedPaywallConstants.Strings.viewPlansButton
            static let dismissButtonTitle = SharedPaywallConstants.Strings.dismissButtonTitle
            
            // Error
            static let errorHeader = SharedPaywallConstants.Strings.errorHeader
        }
    }
}
