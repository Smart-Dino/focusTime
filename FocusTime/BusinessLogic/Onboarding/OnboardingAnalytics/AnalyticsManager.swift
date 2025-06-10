//
//  AnalyticsManager.swift
//  FocusTime
//
//  Created by Keto Nioradze on 30.05.25.
//

import Foundation

// Defines a protocol for analytics managing services.
// This abstraction allows for different analytics implementations (e.g., Firebase)

protocol AnalyticsManager: Sendable {
    func log(event: AnalyticsEvent)
}
