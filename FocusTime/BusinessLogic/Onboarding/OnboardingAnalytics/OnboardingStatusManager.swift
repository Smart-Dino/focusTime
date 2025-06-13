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

    private var persistenceManager: PersistenceManager
    
    var hasCompletedOnboarding: Bool {
        didSet {
            persistenceManager.hasCompletedOnboarding = hasCompletedOnboarding
            delegate?.onboardingStatusDidChange()
        }
    }

    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        self.hasCompletedOnboarding = persistenceManager.hasCompletedOnboarding
        print("OnboardingStatusManager initialized on MainActor. Initial status: \(hasCompletedOnboarding)")
    }
}
