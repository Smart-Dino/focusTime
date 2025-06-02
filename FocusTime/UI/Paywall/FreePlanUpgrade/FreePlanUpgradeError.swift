//
//  FreePlanUpgradeError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 02.06.2025.
//

import Foundation

enum FreePlanUpgradeError: LocalizedError {
    case noProduct
    case invalidProduct
    
    var errorDescription: String? {
        switch self {
        case .noProduct:
            "No product provided."
        case .invalidProduct:
            "Given product doesn't have any trial offers associated with it."
        }
    }
}
