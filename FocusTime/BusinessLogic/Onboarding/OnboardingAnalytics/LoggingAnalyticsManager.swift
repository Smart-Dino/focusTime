//
//  LoggingAnalyticsManager.swift
//  FocusTime
//
//  Created by Keto Nioradze on 30.05.25.
//

import Foundation

// Implementation of the `AnalyticsManaging` protocol that logs events to the console.
// For development and debugging analytics events

final class LoggingAnalyticsManager: AnalyticsManaging, Sendable {
    func log(event: AnalyticsEvent) {
        if let params = event.parameters, !params.isEmpty {
            print("Analytics Event: \(event.name), Parameters: \(params)")
        } else {
            print("Analytics Event: \(event.name)")
        }
    }
}
