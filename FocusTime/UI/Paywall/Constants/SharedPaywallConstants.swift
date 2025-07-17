//
//  SharedPaywallConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.05.2025.
//

import SwiftUI

enum SharedPaywallConstants {
    
    // MARK: - Typography
    enum Fonts {
        static let navigationTitle = Font.system(size: 34,
                                                 weight: .bold)
    }
    
    // MARK: - Strings
    enum Strings {
        static let appName = SharedAppValues.appName ?? String(localized: "shared_paywall_app_name_fallback", table: "PaywallLocalizable")
        static let appSlogan = String(localized: "shared_paywall_app_slogan", table: "PaywallLocalizable")
        
        static let errorHeader = String(localized: "shared_paywall_error_header", table: "PaywallLocalizable")
        static let dismissButtonTitle = String(localized: "shared_paywall_dismiss_button_title", table: "PaywallLocalizable")
        static let viewPlansButton = String(localized: "shared_paywall_view_plans_button", table: "PaywallLocalizable")
        static let subscribeButtonTitle = String(localized: "shared_paywall_subscribe_button_title", table: "PaywallLocalizable")
        // Lifetime
        static let paidOnce = String(localized: "shared_paywall_paid_once", table: "PaywallLocalizable")
        // Button states
        static let loadingTitle = String(localized: "shared_paywall_loading_title", table: "PaywallLocalizable")
        static let pendingTitle = String(localized: "shared_paywall_pending_title", table: "PaywallLocalizable")
        static let subscribeTitle = String(localized: "shared_paywall_subscribe_button_title", table: "PaywallLocalizable")
        static let subscribedTitle = String(localized: "shared_paywall_subscribed_title", table: "PaywallLocalizable")
        static let purchasedTitle = String(localized: "shared_paywall_purchased_title", table: "PaywallLocalizable")
    }
    
}
