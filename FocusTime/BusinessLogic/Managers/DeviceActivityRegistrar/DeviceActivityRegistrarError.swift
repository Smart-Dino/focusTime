//
//  DeviceActivityRegistrarError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.07.2025.
//

import Foundation

enum DeviceActivityRegistrarError: LocalizedError {
    case cannotSuspend
    case noPersistentItem
    case couldNotGenerateIdentifier
    case activityNotFound
    case couldNotCheckOverlap
    case scheduleOverlap(with: [ProtectedBlockItem])
    
    case activityAlreadySuspended
    case activityAlreadyRunning
    case couldNotExtractDatePoints
    
    case noProAccount
    
    var errorDescription: String? {
        switch self {
        case .cannotSuspend:
            String(localized: "device_activity_registrar_cannot_suspend_description", table: "ErrorLocalizable")
        case .noPersistentItem:
            String(localized: "device_activity_registrar_no_persistent_item_description", table: "ErrorLocalizable")
        case .couldNotGenerateIdentifier:
            String(localized: "device_activity_registrar_could_not_generate_identifier_description", table: "ErrorLocalizable")
        case .activityNotFound:
            String(localized: "device_activity_registrar_activity_not_found_description", table: "ErrorLocalizable")
        case .couldNotCheckOverlap:
            String(localized: "device_activity_registrar_could_not_check_overlap_description", table: "ErrorLocalizable")
        case .scheduleOverlap(let blockItems):
            String(
                format: String(localized: "device_activity_registrar_schedule_overlap_description", table: "ErrorLocalizable"),
                blockItems.map { $0.emoji + " " + $0.name }.joined(separator: ", ")
            )
        case .activityAlreadyRunning:
            String(localized: "device_activity_registrar_activity_already_running_description", table: "ErrorLocalizable")
        case .activityAlreadySuspended:
            String(localized: "device_activity_registrar_activity_already_suspended_description", table: "ErrorLocalizable")
        case .couldNotExtractDatePoints:
            String(localized: "device_activity_registrar_could_not_extract_date_points_description", table: "ErrorLocalizable")
        case .noProAccount:
            String(localized: "device_activity_registrar_no_pro_account_description", table: "ErrorLocalizable")
        }
    }
    
    var failureReason: String? {
        switch self {
        case .cannotSuspend:
            String(localized: "device_activity_registrar_cannot_suspend_reason", table: "ErrorLocalizable")
        case .noPersistentItem:
            String(localized: "device_activity_registrar_no_persistent_item_reason", table: "ErrorLocalizable")
        case .couldNotGenerateIdentifier:
            String(localized: "device_activity_registrar_could_not_generate_identifier_reason", table: "ErrorLocalizable")
        case .activityNotFound:
            String(localized: "device_activity_registrar_activity_not_found_reason", table: "ErrorLocalizable")
        case .couldNotCheckOverlap:
            String(localized: "device_activity_registrar_could_not_check_overlap_reason", table: "ErrorLocalizable")
        case .scheduleOverlap:
            String(localized: "device_activity_registrar_schedule_overlap_reason", table: "ErrorLocalizable")
        case .activityAlreadyRunning:
            String(localized: "device_activity_registrar_activity_already_running_reason", table: "ErrorLocalizable")
        case .activityAlreadySuspended:
            String(localized: "device_activity_registrar_activity_already_suspended_reason", table: "ErrorLocalizable")
        case .couldNotExtractDatePoints:
            String(localized: "device_activity_registrar_could_not_extract_date_points_reason", table: "ErrorLocalizable")
        case .noProAccount:
            String(localized: "device_activity_registrar_no_pro_account_reason", table: "ErrorLocalizable")
        }
    }
}
