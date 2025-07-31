//
//  FocusTimeTests.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 02.07.2025.
//

import Testing
import SwiftData
@testable import FocusTime

@Suite("Persistence/Database CRUD tests")
struct PersistenceTests {
    // MARK: - Properties
    let modelContainer: ModelContainer
    
    // MARK: - Initializer
    init() {
        let container = SharedTestHelpers.generateTestModelContainer()
        self.modelContainer = container
    }

    @Test("Test adding to the database.", .tags(.persistenceStore))
    func createAndRead() async throws {
        let blockItemStore = makeStore()
        
        // Add items.
        let insertResults = try await insertTestItems(blockItemStore: blockItemStore)
        
        // Fetch back items.
        let blockItemModel = try await blockItemStore.fetch(id: insertResults.blockItemModelID)
        
        // Evaluate.
        #expect(insertResults.protectedBlockItem.name == blockItemModel.name)
    }
    
    @Test("Test editing items in the database.", .tags(.persistenceStore))
    func update() async throws {
        // New data to edit.
        let newName = "Test name"
        let newEmoji = "👾"
        
        let blockItemStore = makeStore()
        
        // Add items.
        let insertResults = try await insertTestItems(blockItemStore: blockItemStore)
        
        // Update fields.
        try await blockItemStore.updateFields(id: insertResults.blockItemModelID) { blockItemModel in
            blockItemModel.name = newName
            blockItemModel.emoji = newEmoji
        }
        
        // Fetch back items.
        let blockItemModel = try await blockItemStore.fetch(id: insertResults.blockItemModelID)
        
        // Evaluate name.
        #expect(
            blockItemModel.name == newName
        )
        // Evaluate emoji.
        #expect(
            blockItemModel.emoji == newEmoji
        )
    }
    
    @Test("Test removing items from the database.", .tags(.persistenceStore))
    func delete() async throws {
        let blockItemStore = makeStore()
        
        // Add items.
        let insertResults = try await insertTestItems(blockItemStore: blockItemStore)
        
        // Delete items.
        try await blockItemStore.delete(id: insertResults.blockItemModelID)
        
        // Evaluate.
        await #expect(throws: PersistenceStoreError.notFound, performing: {
            let _ = try await blockItemStore.fetch(id: insertResults.blockItemModelID)
        })
    }
}

