//
//  ServiceProtocols.swift
//  FocusTime
//
//  Created by Keto Nioradze on 16.06.25.
//

import Foundation

@MainActor
protocol AnalyticsManager: Sendable {
    func log(event: AnalyticsEvent)
}

@MainActor
protocol OnboardingStatusProviding: Sendable {
    var onboardingProgress: OnboardingProgress { get set }
    var hasCompletedOnboarding: Bool { get set }
}
