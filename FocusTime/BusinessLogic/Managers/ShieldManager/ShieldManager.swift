//
//  BlockManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 24.06.2025.
//

import Foundation
import FamilyControls

enum ShieldManagerError: LocalizedError {
    case noPersistentItem
    case couldNotSetTime
    case couldNotGenerateIdentifier
    
    #warning("No localization")
    var errorDescription: String {
        switch self {
        case .noPersistentItem:
            "Selected item does not exist, make sure you saved your changes."
        case .couldNotSetTime:
            "Unable to set schedule for selected time."
        case .couldNotGenerateIdentifier:
            "Unable to schedule this item."
        }
    }
    
    var failureReason: String {
        switch self {
        case .noPersistentItem:
            "Selected item does not have any persistent item associated with it."
        case .couldNotSetTime:
            "Failed to add 15 minutes to the DateComponents."
        case .couldNotGenerateIdentifier:
            "Could not generate a codable representation of the identifier."
        }
    }
}

@MainActor
protocol ShieldManager {
    // MARK: - Properties
    var isShieldActive: Bool { get }
    // MARK: - Block
    func block() async throws
    func block(specific selection: FamilyActivitySelection) async throws
    func block(specific selections: [FamilyActivitySelection]) async throws
    // MARK: - Unblock
    func unblock() async throws
    func checkAuthorization() async throws 
}
