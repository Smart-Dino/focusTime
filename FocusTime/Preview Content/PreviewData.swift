//
//  PreviewData.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//

import SwiftData
import Foundation

#if DEBUG
enum PreviewData {
    static let memoryOnlyModelContainer = try! ModelContainer(
        for: .init([BlockItem.self, Schedule.self]),
        configurations: [
            .init(isStoredInMemoryOnly: true)
        ]
    )
    static let relationshipCoordinator = RelationshipCoordinator(modelContainer: Self.memoryOnlyModelContainer)
}
#endif
