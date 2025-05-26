//
//  PlanSelectionPaywallError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.05.2025.
//

import Foundation

enum PlanSelectionPaywallError: LocalizedError {
    case missingTrialInfo
    
    var errorDescription: String? {
        switch self {
        case .missingTrialInfo:
            "The trial information could not be retrieved."
        }
    }
}

