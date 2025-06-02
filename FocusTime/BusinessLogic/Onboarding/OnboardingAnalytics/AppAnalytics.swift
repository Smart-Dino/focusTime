//
//  AppAnalytics.swift
//  FocusTime
//
//  Created by Keto Nioradze on 30.05.25.
//

import Foundation

// Provides a centralized, shared access point to the analytics service.
// It uses a singleton-like pattern to ensure a single instance of the analytics manager is used throughout the app.

struct AppAnalytics {
    static let shared: AnalyticsManaging = LoggingAnalyticsManager()

    private init() {}
}
