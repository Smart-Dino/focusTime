//
//  ShieldManagerError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 10.07.2025.
//

import Foundation

enum ShieldManagerError: LocalizedError {
    case noPersistentItem
    case couldNotSetTime
    case couldNotGenerateIdentifier

    var errorDescription: String {
        switch self {
        case .noPersistentItem:
            String(localized: "shield_error_no_persistent_item_description", table: "ErrorLocalizable")
        case .couldNotSetTime:
            String(localized: "shield_error_could_not_set_time_description", table: "ErrorLocalizable")
        case .couldNotGenerateIdentifier:
            String(localized: "shield_error_could_not_generate_identifier_description", table: "ErrorLocalizable")
        }
    }

    var failureReason: String {
        switch self {
        case .noPersistentItem:
            String(localized: "shield_error_no_persistent_item_reason", table: "ErrorLocalizable")
        case .couldNotSetTime:
            String(localized: "shield_error_could_not_set_time_reason", table: "ErrorLocalizable")
        case .couldNotGenerateIdentifier:
            String(localized: "shield_error_could_not_generate_identifier_reason", table: "ErrorLocalizable")
        }
    }
}
