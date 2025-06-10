//
//  OnboardingStatusManager.swift
//  FocusTime
//
//  Created by Keto Nioradze on 04.06.25.
//

import Foundation
import SwiftUI
import Observation

protocol OnboardingStatusProviding: Sendable {
    @MainActor var hasCompletedOnboarding: Bool { get set }
}

@MainActor
@Observable
class OnboardingStatusManager: OnboardingStatusProviding {
    var onStatusDidChange: (() -> Void)?

    @AppStorage("hasCompletedOnboarding")
    @ObservationIgnored
    var hasCompletedOnboarding: Bool = false {
        didSet {
            onStatusDidChange?()
        }
    }

    init() {
        print("OnboardingStatusManager initialized on MainActor. Initial status: \(hasCompletedOnboarding)")
    }
}
