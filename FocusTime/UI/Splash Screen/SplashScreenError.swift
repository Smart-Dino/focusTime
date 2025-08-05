//
//  SplashScreenError.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.08.2025.
//

import Foundation

enum SplashScreenError: LocalizedError {
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            String(localized: "splash_screen_error_invalid_url_description", table: "ErrorLocalizable")
        }
    }
}
