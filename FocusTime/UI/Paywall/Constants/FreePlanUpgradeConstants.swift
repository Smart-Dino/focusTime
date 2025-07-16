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
            static let upgradeMessage = AttributedString(localized: "free_plan_upgrade_message", table: "PaywallLocalizable")
            
            // Title of the view.
            static let title = String(localized: "free_plan_upgrade_title", table: "PaywallLocalizable")
            
            // Loading state
            static let loadingTitle = SharedPaywallConstants.Strings.loadingTitle
            
            // Purchase button states
            static let tryButtonTitle: String = {
                let localPrice = Decimal(0).formatted(
                    .currency(code: Locale.current.currency?.identifier ?? "USD")
                        .presentation(.narrow)
                        .rounded()
                )
                let formatString = String(localized: "free_plan_upgrade_try_for_price", table: "PaywallLocalizable")
                return String(format: formatString, localPrice)
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
