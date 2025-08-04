//
//  PersistenceTests+Helpers.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 02.07.2025.
//

import Testing
import SwiftData
import Foundation
import FamilyControls
@testable import FocusTime

// MARK: - Helpers
extension PersistenceTests {
    func makeProtectedTestBlockItem(name: String = UUID().uuidString) throws -> ProtectedBlockItem {
        let weekdays: Set<Weekday> = Weekday.weekdays
        let start = try TimeComponents(hour: 9, minute: 0)
        let end = try TimeComponents(hour: 17, minute: 0)
        let selection = FamilyActivitySelection()
        return ProtectedBlockItem(
            emoji: "🔒",
            name: name,
            days: weekdays,
            type: .scheduled(startTime: start, endTime: end),
            blockedContent: ProtectedActivitySelection(selection),
        )
    }
    
    func makeStore() -> BlockItemStore {
        return BlockItemStore(modelContainer: modelContainer)
    }

    func insertTestItems(
        blockItemStore: BlockItemStore
    ) async throws -> (
        blockItemModelID: PersistentIdentifier,
        protectedBlockItem: ProtectedBlockItem
    ) {
        // Generate test items.
        let blockItem = try makeProtectedTestBlockItem()
        
        // Insert items to the database and get back their IDs.
        let blockItemID = try await blockItemStore.insert(blockItem)
        
        return (blockItemID, blockItem)
    }
}
