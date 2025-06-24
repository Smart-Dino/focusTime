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
        static let appName = "DeepWave"
        static let appSlogan = "Focus within minutes"
        
        static let errorHeader = "An error occurred"
        static let dismissButtonTitle = "Dismiss current screen."
        static let viewPlansButton = "View All Plans"
        static let subscribeButtonTitle = "Subscribe"
        // Lifetime
        static let paidOnce = "Paid once"
        // Button states
        static let loadingTitle = "Loading..."
        static let pendingTitle = "Pending..."
        static let subscribeTitle = "Subscribe"
        static let subscribedTitle = "Subscribed!"
        static let purchasedTitle = "Purchased!"
    }
    
    // MARK: - Typography
    enum Fonts {
        static let navigationTitle = Font.system(size: 34,
                                                 weight: .bold)
    }
    
}
