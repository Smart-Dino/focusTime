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
            static let upgradeMessage = AttributedString(localized: "Upgrade to have unlimited scheduled sessions with **Pro version**", table: "PaywallLocalizable")
            
            // Title of the view.
            static let title = String(localized: "You're on a Free Plan", table: "PaywallLocalizable")
            
            // Loading state
            static let loadingTitle = SharedPaywallConstants.Strings.loadingTitle
            
            // Purchase button states
            static let tryButtonTitle: String = {
                let localPrice = Decimal(0).formatted(
                    .currency(code: Locale.current.currency?.identifier ?? "USD")
                        .presentation(.narrow)
                        .rounded()
                )
                return String(localized: "Try For \(localPrice)", table: "PaywallLocalizable")
            }()
            
            static let pendingTitle = SharedPaywallConstants.Strings.pendingTitle
            static let subscribedTitle = SharedPaywallConstants.Strings.subscribedTitle
            
            // Other buttons
            static let viewPlansButton = SharedPaywallConstants.Strings.viewPlansButton
            static let dismissButtonTitle = SharedPaywallConstants.Strings.dismissButtonTitle
            
            // Error
            static let errorHeader = SharedPaywallConstants.Strings.errorHeader
        }
    }
}
