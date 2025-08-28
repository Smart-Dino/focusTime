//
//  BlockState.swift
//  FocusTime
//
//  Created by Maksym Horobets on 22.08.2025.
//

import Foundation

enum BlockState {
    case running, inactive, suspended, suspendedIndefinitely
    
    var isActive: Bool {
        switch self {
        case .running: true
        case .inactive: false
        case .suspended: true
        case .suspendedIndefinitely: true
        }
    }
}
