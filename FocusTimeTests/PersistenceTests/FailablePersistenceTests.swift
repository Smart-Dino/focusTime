//
//  FailablePersistenceTests.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 02.07.2025.
//

import Testing
@testable import FocusTime

extension PersistenceTests {
    @Test("Simulate reading a non-existent object.")
    func readFail() async throws {
        let blockItemStore = makeStore()
        
        // Insert some items.
        let insertResults = try await insertTestItems(blockItemStore: blockItemStore)
        
        // Remove these items by their PersistentIdentifier.
        try await blockItemStore.delete(id: insertResults.blockItemModelID)
        
        // Evaluate.
        // We expect the PersistenceStoreError.notFound error to be thrown
        // while performing the fetch of non-existent items.
        await #expect(throws: PersistenceStoreError.notFound, performing: {
            try await blockItemStore.fetch(id: insertResults.blockItemModelID)
        })
    }
}
