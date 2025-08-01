//
//  DefaultsManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import Foundation

protocol DefaultsManager {
    init(defaults: UserDefaults)
    
    func setValue(for key: SharedAppValues.DefaultsKeys, to value: Any)
    func getValue(for key: SharedAppValues.DefaultsKeys) -> Any?
}
