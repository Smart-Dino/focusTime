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
    private var persistenceManager: OnboardingPersistenceManaging
    
    var onboardingProgress: OnboardingProgress {
            didSet {
                persistenceManager.onboardingProgress = onboardingProgress
                delegate?.onboardingStatusDidChange()
            }
        }
    
    var hasCompletedOnboarding: Bool {
        get { onboardingProgress == .completed }
        set {
            onboardingProgress = newValue ? .completed : .quiz
        }
    }
    
    init(persistenceManager: OnboardingPersistenceManaging) {
        self.persistenceManager = persistenceManager
        self.onboardingProgress = persistenceManager.onboardingProgress
        print("OnboardingStatusManager initialized on MainActor. Initial progress: \(onboardingProgress)")
    }
}
