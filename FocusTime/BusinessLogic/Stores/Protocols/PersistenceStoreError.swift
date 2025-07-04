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
    
    #warning("Not localized error description.")
    var errorDescription: String? {
        switch self {
        case .notFound:
            "We couldn't find what you were looking for. (Developer info: Model not found in ModelContext.)"
        case .noIdentifier:
            "Something went wrong while finding this item. (Developer info: No identifier found during conversion; attempted to fetch a model that may not exist with ProtectedModel.)"
        case .alreadyRelated:
            "The two items being added to one another already have form a relationship. The action is aborted."
        }
    }
}
