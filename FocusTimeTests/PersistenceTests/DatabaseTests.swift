//
//  FocusTimeTests.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 02.07.2025.
//

import Testing
import SwiftData
import Foundation
import FamilyControls
@testable import FocusTime

@Suite("Basic Persistence/Database CRUD tests")
struct BasicPersistenceTests {
    // MARK: - Properties
    let modelContainer: ModelContainer
    
    // MARK: - Initializer
    init() {
        let schema = Schema([BlockItem.self, Schedule.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true, groupContainer: .identifier(AppValues.appGroupIdentifier))
        let container = try! ModelContainer(for: schema, configurations: config)
        self.modelContainer = container
    }

    @Test("Test adding to the database.")
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
    
    @Test("Test editing items in the database.")
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
    
    @Test("Test removing items from the database.")
    func delete() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        let insertResults = try await insertTestItems(scheduleStore: scheduleStore,
                                                      blockItemStore: blockItemStore)
        
        try await scheduleStore.delete(id: insertResults.scheduleModelID)
        try await blockItemStore.delete(id: insertResults.blockItemModelID)
        
        await #expect(throws: DataSourceError.notFound, performing: {
            let _ = try await scheduleStore.fetch(id: insertResults.scheduleModelID)
            let _ = try await blockItemStore.fetch(id: insertResults.blockItemModelID)
        })
    }
}

// MARK: - Helpers
extension BasicPersistenceTests {
    func makeProtectedTestBlockItem() -> ProtectedBlockItem {
        let selection = FamilyActivitySelection()
        return ProtectedBlockItem(
            emoji: "🔒",
            name: UUID().uuidString,
            blockedContent: selection,
            schedulesDescription: "No schedules"
        )
    }
    func makeProtectedTestSchedule() -> ProtectedSchedule {
        let weekdays: Set<Weekday> = Weekday.weekdays
        let start = TimeComponents(hour: 9, minute: 0)!
        let end = TimeComponents(hour: 17, minute: 0)!
        return ProtectedSchedule(
            emoji: "📅",
            name: UUID().uuidString,
            days: weekdays,
            startTime: start,
            endTime: end,
            daysDescription: "Weekdays"
        )
    }
    
    func makeStores() -> (ScheduleStore, BlockItemStore) {
        return (
            ScheduleStore(modelContainer: modelContainer),
            BlockItemStore(modelContainer: modelContainer)
        )
    }

    func insertTestItems(
        scheduleStore: ScheduleStore,
        blockItemStore: BlockItemStore
    ) async throws -> (
        scheduleModelID: Schedule.ID,
        blockItemModelID: BlockItem.ID,
        protectedSchedule: ProtectedSchedule,
        protectedBlockItem: ProtectedBlockItem
    ) {
        // Generate test items.
        let schedule = makeProtectedTestSchedule()
        let blockItem = makeProtectedTestBlockItem()
        // Insert items to the database and get back their IDs.
        let scheduleID = try await scheduleStore.insert(schedule)
        let blockItemID = try await blockItemStore.insert(blockItem)
        
        return (scheduleID, blockItemID, schedule, blockItem)
    }
}
