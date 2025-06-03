//
//  OnboardingPaywallError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.05.2025.
//

import Foundation

enum OnboardingPaywallError: LocalizedError {
    case noTrialOption
    case invalidProduct
    
    var errorDescription: String? {
        switch self {
        case .noTrialOption:
            "No trialable option was returned to the method."
        case .invalidProduct:
            "Given product doesn't have any trial offers associated with it."
        }
    }
}
