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
            String(localized: "Selected item does not exist, make sure you saved your changes.", table: "ErrorLocalizable")
        case .couldNotSetTime:
            String(localized: "Unable to set schedule for selected time.", table: "ErrorLocalizable")
        case .couldNotGenerateIdentifier:
            String(localized: "Unable to schedule this item.", table: "ErrorLocalizable")
        }
    }

    var failureReason: String {
        switch self {
        case .noPersistentItem:
            String(localized: "Selected item does not have any persistent item associated with it.", table: "ErrorLocalizable")
        case .couldNotSetTime:
            String(localized: "Failed to add 15 minutes to the DateComponents.", table: "ErrorLocalizable")
        case .couldNotGenerateIdentifier:
            String(localized: "Could not generate a codable representation of the identifier.", table: "ErrorLocalizable")
        }
    }
}
