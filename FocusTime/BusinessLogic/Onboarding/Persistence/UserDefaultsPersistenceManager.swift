//
//  UserDefaultsPersistenceManager.swift
//  FocusTime
//
//  Created by Keto Nioradze on 13.06.25.
//

import Foundation

final class UserDefaultsPersistenceManager: PersistenceManager {
    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var hasCompletedOnboarding: Bool {
        get {
            userDefaults.bool(forKey: Keys.hasCompletedOnboarding)
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.hasCompletedOnboarding)
        }
    }
}
