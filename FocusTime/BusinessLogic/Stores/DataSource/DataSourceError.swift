//
//  DataSourceError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 20.06.2025.
//

import Foundation

enum DataSourceError: LocalizedError {
    case notFound
    case noIdentifier
    
    #warning("Not localized error description.")
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "We couldn't find what you were looking for. (Developer info: Model not found in ModelContext.)"
        case .noIdentifier:
            return "Something went wrong while finding this item. (Developer info: No identifier found during conversion; attempted to fetch a model that may not exist with ProtectedModel.)"
        }
    }
}
