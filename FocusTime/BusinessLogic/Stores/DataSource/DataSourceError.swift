//
//  DataSourceError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 20.06.2025.
//

import Foundation

enum DataSourceError: LocalizedError {
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            String(localized: "The requested model was not found in the modelContext.", table: "ErrorLocalizable")
        }
    }
}
