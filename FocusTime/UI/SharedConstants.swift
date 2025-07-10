//
//  SharedPaywallConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.05.2025.
//

import SwiftUI

enum SharedConstants {
    
    // MARK: - Strings
    enum Strings {
        static let appName = SharedAppValues.appName ?? String(localized: "App Name", table: "PaywallLocalizable")
        static let appSlogan = String(localized: "Focus within minutes", table: "PaywallLocalizable")
        
        static let errorHeader = String(localized: "An error occurred", table: "PaywallLocalizable")
        static let dismissButtonTitle = String(localized: "Dismiss current screen.", table: "PaywallLocalizable")
        static let viewPlansButton = String(localized: "View All Plans", table: "PaywallLocalizable")
        static let subscribeButtonTitle = String(localized: "Subscribe", table: "PaywallLocalizable")
        // Lifetime
        static let paidOnce = String(localized: "Paid once", table: "PaywallLocalizable")
        // Button states
        static let loadingTitle = String(localized: "Loading...", table: "PaywallLocalizable")
        static let pendingTitle = String(localized: "Pending...", table: "PaywallLocalizable")
        static let subscribeTitle = String(localized: "Subscribe", table: "PaywallLocalizable")
        static let subscribedTitle = String(localized: "Subscribed!", table: "PaywallLocalizable")
        static let purchasedTitle = String(localized: "Purchased!", table: "PaywallLocalizable")
    }
    
    // MARK: - Typography
    enum Fonts {
        static let navigationTitle = Font.system(size: 34,
                                                 weight: .bold)
    }
    
}
