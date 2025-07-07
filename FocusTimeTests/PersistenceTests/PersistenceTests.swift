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
    let coordinator: RelationshipCoordinator
    
    // MARK: - Initializer
    init() {
        let container = SharedTestHelpers.generateTestModelContainer()
        self.modelContainer = container
        self.coordinator = RelationshipCoordinator(modelContainer: container)
    }

    @Test("Test adding to the database.", .tags(.persistenceStore))
    func createAndRead() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        let insertResults = try await insertTestItems(scheduleStore: scheduleStore,
                                                      blockItemStore: blockItemStore)
        
        // Fetch back items.
        let scheduleModel = try #require(try await scheduleStore.fetch(id: insertResults.scheduleModelID))
        let blockItemModel = try #require(try await blockItemStore.fetch(id: insertResults.blockItemModelID))
        
        // Evaluate.
        #expect(insertResults.protectedSchedule.name == scheduleModel.name)
        #expect(insertResults.protectedBlockItem.name == blockItemModel.name)
    }
    
    @Test("Test editing items in the database.", .tags(.persistenceStore))
    func update() async throws {
        // New data to edit.
        let newName = "Test name"
        let newEmoji = "👾"
        
        // Insert.
        let (scheduleStore, blockItemStore) = makeStores()
        let insertResults = try await insertTestItems(scheduleStore: scheduleStore,
                                                      blockItemStore: blockItemStore)
        
        // Update fields.
        try await scheduleStore.updateFields(id: insertResults.scheduleModelID) { scheduleModel in
            scheduleModel.name = newName
            scheduleModel.emoji = newEmoji
        }
        try await blockItemStore.updateFields(id: insertResults.blockItemModelID) { blockItemModel in
            blockItemModel.name = newName
            blockItemModel.emoji = newEmoji
        }
        
        // Fetch back items.
        let scheduleModel = try #require(try await scheduleStore.fetch(id: insertResults.scheduleModelID))
        let blockItemModel = try #require(try await blockItemStore.fetch(id: insertResults.blockItemModelID))
        
        // Evaluate name.
        #expect(
            scheduleModel.name == newName
            && blockItemModel.name == newName
        )
        // Evaluate emoji.
        #expect(
            scheduleModel.emoji == newEmoji
            && blockItemModel.emoji == newEmoji
        )
    }
    
    @Test("Test removing items from the database.", .tags(.persistenceStore))
    func delete() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        
        // Add items.
        let insertResults = try await insertTestItems(scheduleStore: scheduleStore,
                                                      blockItemStore: blockItemStore)
        
        // Delete items.
        try await scheduleStore.delete(id: insertResults.scheduleModelID)
        try await blockItemStore.delete(id: insertResults.blockItemModelID)
        
        // Evaluate.
        await #expect(throws: PersistenceStoreError.notFound, performing: {
            let _ = try await scheduleStore.fetch(id: insertResults.scheduleModelID)
            let _ = try await blockItemStore.fetch(id: insertResults.blockItemModelID)
        })
    }
}

