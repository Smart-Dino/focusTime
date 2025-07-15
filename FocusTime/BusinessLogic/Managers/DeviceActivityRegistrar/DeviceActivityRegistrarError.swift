//
//  DeviceActivityRegistrarError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.07.2025.
//

import Foundation

enum DeviceActivityRegistrarError: LocalizedError {
    case noPersistentItem
    case couldNotGenerateIdentifier
    case couldNotSetTime
    case activityNotFound
    
    var errorDescription: String? {
        switch self {
        case .noPersistentItem:
            return String(localized: "Selected item does not exist, make sure you saved your changes.", table: "ErrorLocalizable")
        case .couldNotGenerateIdentifier:
            return String(localized: "Unable to schedule this item.", table: "ErrorLocalizable")
        case .couldNotSetTime:
            return String(localized: "Unable to set schedule for selected time.", table: "ErrorLocalizable")
        case .activityNotFound:
            return String(localized: "Could not find the registered device activity.", table: "ErrorLocalizable")
        }
    }
    
    var failureReason: String? {
        switch self {
        case .noPersistentItem:
            return String(localized: "Selected item does not have any persistent item associated with it.", table: "ErrorLocalizable")
        case .couldNotGenerateIdentifier:
            return String(localized: "Could not generate a codable representation of the identifier.", table: "ErrorLocalizable")
        case .couldNotSetTime:
            return String(localized: "Failed to add 15 minutes to the DateComponents.", table: "ErrorLocalizable")
        case .activityNotFound:
            return String(localized: "No matching activity was found in DeviceActivityCenter for the provided identifier.", table: "ErrorLocalizable")
        }
    }
}
