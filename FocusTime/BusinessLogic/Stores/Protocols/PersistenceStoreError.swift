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
            return String(localized: "We couldn't find what you were looking for.", table: "ErrorLocalizable")
        case .noIdentifier:
            return String(localized: "Something went wrong while finding this item.", table: "ErrorLocalizable")
        case .alreadyRelated:
            return String(localized: "The two items being added to one another already form a relationship. The action is aborted.", table: "ErrorLocalizable")
        }
    }
    
    var failureReason: String? {
        switch self {
        case .notFound:
            return String(localized: "Model not found in ModelContext.", table: "ErrorLocalizable")
        case .noIdentifier:
            return String(localized: "No identifier found during conversion; attempted to fetch a model that may not exist with ProtectedModel.", table: "ErrorLocalizable")
        case .alreadyRelated:
            return nil
        }
    }
}
