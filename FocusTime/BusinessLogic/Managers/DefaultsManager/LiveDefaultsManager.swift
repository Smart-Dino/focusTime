//
//  LiveDefaultsManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import Foundation

struct LiveDefaultsManager: DefaultsManager {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func setValue<T>(for key: SharedAppValues.DefaultsKeys, to value: T) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func getValue<T>(for key: SharedAppValues.DefaultsKeys) -> T? {
        defaults.object(forKey: key.rawValue) as? T
    }
}
