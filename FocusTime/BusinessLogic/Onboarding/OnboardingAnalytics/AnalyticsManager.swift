//
//  AnalyticsManager.swift
//  FocusTime
//
//  Created by Keto Nioradze on 30.05.25.
//

import Foundation

protocol AnalyticsManaging: Sendable {
    func log(event: AnalyticsEvent) 
}
