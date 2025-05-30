//
//  AppAnalytics.swift
//  FocusTime
//
//  Created by Keto Nioradze on 30.05.25.
//

import Foundation

struct AppAnalytics {
    static let shared: AnalyticsManaging = LoggingAnalyticsManager()

    private init() {}
}
