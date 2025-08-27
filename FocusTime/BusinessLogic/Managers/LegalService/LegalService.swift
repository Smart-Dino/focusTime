//
//  LegalService.swift
//  FocusTime
//
//  Created by Maksym Horobets on 27.08.2025.
//

import Foundation

enum PolicyType {
    case termsOfService
    case privacyPolicy
    
    var url: URL? {
        switch self {
        case .termsOfService:
            URL(string: "https://raw.githubusercontent.com/Smart-Dino/focus-time-legal/refs/heads/main/terms_of_use.txt")
        case .privacyPolicy:
            URL(string: "https://raw.githubusercontent.com/Smart-Dino/focus-time-legal/refs/heads/main/privacy_policy.txt")
        }
    }
}

@MainActor
protocol LegalService: AnyObject {
    func requestContents(for type: PolicyType) async throws -> String
}
