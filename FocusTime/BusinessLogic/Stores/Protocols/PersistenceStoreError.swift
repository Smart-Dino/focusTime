//
//  DataSourceError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 20.06.2025.
//

import Foundation

enum PersistenceStoreError: LocalizedError {
    case notFound
    case noIdentifier
    case alreadyRelated
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            String(localized: "persistence_error_not_found_description", table: "ErrorLocalizable")
        case .noIdentifier:
            String(localized: "persistence_error_no_identifier_description", table: "ErrorLocalizable")
        case .alreadyRelated:
            String(localized: "persistence_error_already_related_description", table: "ErrorLocalizable")
        }
    }
    
    var failureReason: String? {
        switch self {
        case .notFound:
            String(localized: "persistence_error_not_found_reason", table: "ErrorLocalizable")
        case .noIdentifier:
            String(localized: "persistence_error_no_identifier_reason", table: "ErrorLocalizable")
        case .alreadyRelated:
            nil
        }
    }
}
