//
//  ShieldDebugError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//

import Foundation

enum ShieldDebugError: LocalizedError {
    case timeComponent
    
    var errorDescription: String {
        switch self {
        case .timeComponent:
            "Invalid time components."
        }
    }
}
