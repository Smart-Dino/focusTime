//
//  LiveLegalService.swift
//  FocusTime
//
//  Created by Maksym Horobets on 27.08.2025.
//

import Foundation

@MainActor
final class LiveLegalService: LegalService {
    func requestContents(for type: PolicyType) async throws -> String {
        guard let url = type.url else { throw LegalServiceError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw LegalServiceError.badResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw LegalServiceError.badResponse
        }
        
        return String(decoding: data, as: UTF8.self)
    }
}
