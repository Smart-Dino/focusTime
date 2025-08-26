//
//  AnalyticsManager.swift
//  FocusTime
//
//  Created by Keto Nioradze on 21.08.25.
//

import Foundation
import FirebaseAnalytics

protocol AnalyticsManagerProtocol {
    func logEvent(name: String, parameters: [String: Any]?)
}

/// Concrete implementation of `AnalyticsManagerProtocol` that uses Firebase Analytics.
final class LiveAnalyticsManager: AnalyticsManagerProtocol {
    
    init() {}
    
    /// Logs a Firebase Analytics event.
    /// - Parameters:
    ///   - name: The name of the event.
    ///   - parameters: A dictionary of event parameters.
    func logEvent(name: String, parameters: [String: Any]?) {
        Analytics.logEvent(name, parameters: parameters)
        print("Logged event: \(name); parameters: \(parameters ?? [:])")
    }
}
