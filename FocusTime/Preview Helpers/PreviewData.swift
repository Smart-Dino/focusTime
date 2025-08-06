//
//  PreviewData.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//

import SwiftData
import Foundation

enum PreviewData {
    static let memoryOnlyModelContainer: ModelContainer = {
        do {
            return try ModelContainer(
                for: .init([BlockItem.self, Schedule.self]),
                configurations: [
                    .init(isStoredInMemoryOnly: true)
                ]
            )
        } catch {
            fatalError("Failed to create preview ModelContainer: \(error)")
        }
    }()
    static let relationshipCoordinator = RelationshipCoordinator(modelContainer: Self.memoryOnlyModelContainer)
}
