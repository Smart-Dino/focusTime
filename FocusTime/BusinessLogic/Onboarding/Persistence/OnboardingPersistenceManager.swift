//
//  OnboardingPersistenceManager.swift
//  FocusTime
//
//  Created by Keto Nioradze on 13.06.25.
//

import Foundation

final class OnboardingPersistenceManager: OnboardingPersistenceManaging {
    private enum Keys {
        static let onboardingProgress = "onboardingProgress"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var onboardingProgress: OnboardingProgress {
            get {
                let savedProgressString = userDefaults.string(forKey: Keys.onboardingProgress)
                return OnboardingProgress(rawValue: savedProgressString ?? "") ?? .quiz
            }
            set {
                userDefaults.setValue(newValue.rawValue, forKey: Keys.onboardingProgress)
            }
        }
    }
