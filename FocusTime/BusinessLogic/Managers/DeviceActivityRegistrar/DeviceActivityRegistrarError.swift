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
            String(localized: "device_activity_registrar_no_persistent_item_description", table: "ErrorLocalizable")
        case .couldNotGenerateIdentifier:
            String(localized: "device_activity_registrar_could_not_generate_identifier_description", table: "ErrorLocalizable")
        case .couldNotSetTime:
            String(localized: "device_activity_registrar_could_not_set_time_description", table: "ErrorLocalizable")
        case .activityNotFound:
            String(localized: "device_activity_registrar_activity_not_found_description", table: "ErrorLocalizable")
        }
    }
    
    var failureReason: String? {
        switch self {
        case .noPersistentItem:
            String(localized: "device_activity_registrar_no_persistent_item_reason", table: "ErrorLocalizable")
        case .couldNotGenerateIdentifier:
            String(localized: "device_activity_registrar_could_not_generate_identifier_reason", table: "ErrorLocalizable")
        case .couldNotSetTime:
            String(localized: "device_activity_registrar_could_not_set_time_reason", table: "ErrorLocalizable")
        case .activityNotFound:
            String(localized: "device_activity_registrar_activity_not_found_reason", table: "ErrorLocalizable")
        }
    }
}
