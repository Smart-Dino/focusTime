//
//  OnboardingStatusManager.swift
//  FocusTime
//
//  Created by Keto Nioradze on 04.06.25.
//

import SwiftUI

@MainActor
@Observable
class OnboardingStatusManager: OnboardingStatusProviding {
    weak var delegate: OnboardingStatusManagerDelegate?

    @AppStorage("hasCompletedOnboarding")
    @ObservationIgnored
    var hasCompletedOnboarding: Bool = false {
        didSet {
            delegate?.onboardingStatusDidChange()
        }
    }

    init() {
        print("OnboardingStatusManager initialized on MainActor. Initial status: \(hasCompletedOnboarding)")
    }
}
