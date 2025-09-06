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
            static let loadingTitle = SharedConstants.Strings.loadingTitle
            
            static func subscribeButtonTitle(product: FTProduct) -> String {
                let price = product.priceString
                if product.isFreeTrialAvailable {
                    let formatString = String(localized: "free_plan_upgrade_subscribe_for_price", table: "PaywallLocalizable")
                    return String(format: formatString, price)
                } else {
                    return String(localized: "try_for_free_title", table: "PaywallLocalizable")
                }
            }
            
            // Purchase button states
            static func tryButtonTitle(product: FTProduct) -> String{
                let price = Decimal(0).formatted(product.priceFormatStyle)
                let formatString = String(localized: "free_plan_upgrade_try_for_price", table: "PaywallLocalizable")
                return String(format: formatString, price)
            }
            
            static let pendingTitle = SharedConstants.Strings.pendingTitle
            static let subscribedTitle = SharedConstants.Strings.subscribedTitle
            
            // Other buttons
            static let viewPlansButton = SharedConstants.Strings.viewPlansButton
            
            // Error
            static let errorHeader = SharedConstants.Strings.errorHeader
        }
    }
}
