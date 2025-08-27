//
//  LegalServiceError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 27.08.2025.
//

import Foundation

enum LegalServiceError: LocalizedError {
    case invalidURL
    case badResponse
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            String(localized: "legal_service_error_invalid_url", table: "ErrorLocalizable")
        case .badResponse:
            String(localized: "legal_service_error_bad_response", table: "ErrorLocalizable")
        }
    }
}
