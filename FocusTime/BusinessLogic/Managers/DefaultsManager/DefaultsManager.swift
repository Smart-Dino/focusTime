//
//  DefaultsManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import Foundation

protocol DefaultsManager {
    init(defaults: UserDefaults)
    
    func setValue<T>(for key: SharedAppValues.DefaultsKeys, to value: T)
    func getValue<T>(for key: SharedAppValues.DefaultsKeys) -> T?
}
