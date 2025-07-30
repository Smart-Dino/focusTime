//
//  SharedConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.05.2025.
//

import SwiftUI

enum SharedConstants {
    
    // MARK: - Strings
    enum Strings {
        static let appName = SharedAppValues.appName ?? String(localized: "shared_app_name_fallback", table: "SharedLocalizable")
        static let appSlogan = String(localized: "shared_app_slogan", table: "SharedLocalizable")
        
        static let errorHeader = String(localized: "shared_error_header", table: "SharedLocalizable")
        static let viewPlansButton = String(localized: "shared_view_plans_button", table: "SharedLocalizable")
        static let subscribeButtonTitle = String(localized: "shared_subscribe_button_title", table: "SharedLocalizable")
        // Lifetime
        static let paidOnce = String(localized: "shared_paid_once", table: "SharedLocalizable")
        // Button states
        static let loadingTitle = String(localized: "shared_loading_title", table: "SharedLocalizable")
        static let pendingTitle = String(localized: "shared_pending_title", table: "SharedLocalizable")
        static let subscribedTitle = String(localized: "shared_subscribed_title", table: "SharedLocalizable")
        static let purchasedTitle = String(localized: "shared_purchased_title", table: "SharedLocalizable")
    }
    
    // MARK: - Typography
    enum Fonts {
        static let navigationTitle = Font.system(size: 34,
                                                 weight: .bold)
    }
    
}
