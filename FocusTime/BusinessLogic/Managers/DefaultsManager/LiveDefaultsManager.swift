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
    
    func setValue(for key: SharedAppValues.DefaultsKeys, value: Any) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func getValue(for key: SharedAppValues.DefaultsKeys) -> Any? {
        defaults.object(forKey: key.rawValue)
    }
}
