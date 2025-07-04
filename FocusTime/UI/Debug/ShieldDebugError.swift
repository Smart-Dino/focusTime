//
//  ShieldDebugError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//

import Foundation

enum ShieldDebugError: LocalizedError {
    case timeComponent
    case invalidPersistentIdentifiers
    
    var errorDescription: String {
        switch self {
        case .timeComponent:
            "Invalid time components."
        case .invalidPersistentIdentifiers:
            "Provided persistence identifiers do not exist."
        }
    }
}
