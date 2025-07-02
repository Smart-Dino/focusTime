//
//  AdditionalPersistenceTests.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 02.07.2025.
//

import Testing
import SwiftData
import Foundation
import FamilyControls
@testable import FocusTime

extension PersistenceTests {
    
    @Test("Heavy, large amounts of inserts")
    func batchInserts() async throws {
        // Set an amount of items to insert into each Store.
        let eachItemCount = 1000
        let (scheduleStore, blockItemStore) = makeStores()
        
        // Generate schedules.
        let schedulesToInsert = Array(
            repeating: ProtectedSchedule(
                emoji: "🏠",
                name: "Spend time with family",
                days: [.saturday, .sunday],
                startTime: TimeComponents(hour: 17, minute: 00)!,
                endTime: TimeComponents(hour: 19, minute: 00)!
            ),
            count: eachItemCount
        )
        // Generate block items.
        let blockItemsToInsert = Array(
            repeating: ProtectedBlockItem(
                emoji: "😜",
                name: "Block",
                blockedContent: FamilyActivitySelection()
            ),
            count: eachItemCount
        )
        
        // Batch insert into stores.
        // Important: Use insertBatch for large amounts of data for better performance.
        try await scheduleStore.insertBatch(schedulesToInsert)
        try await blockItemStore.insertBatch(blockItemsToInsert)
        
        // Evaluate.
        let schedulesCount = try await scheduleStore.fetch().count
        let blockItemCount = try await blockItemStore.fetch().count
        
        #expect(
            schedulesCount == eachItemCount
            && blockItemCount == eachItemCount
        )
    }
    
    @Test("Erasing all of the database's data")
    func eraseModel() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        
        // Make sure contexts are empty.
        try #require(try await scheduleStore.fetch().isEmpty)
        try #require(try await blockItemStore.fetch().isEmpty)
        
        // Insert items.
        let _ = try await insertTestItems(scheduleStore: scheduleStore,
                                          blockItemStore: blockItemStore)
        
        // Make sure they are not empty anymore.
        try #require(!(try await scheduleStore.fetch().isEmpty))
        try #require(!(try await blockItemStore.fetch().isEmpty))
        
        // Erase all data.
        try await scheduleStore.eraseAllData()
        try await blockItemStore.eraseAllData()
        
        // Evaluate.
        #expect(try await scheduleStore.fetch().isEmpty)
        #expect(try await blockItemStore.fetch().isEmpty)
    }
    
    @Test("Fetching models from database using FetchDescriptor")
    func fetchUsingDescriptor() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        let customName = "Custom Test Name"
        
        // Generate test items.
        let schedule = makeProtectedTestSchedule(name: customName)
        let blockItem = makeProtectedTestBlockItem(name: customName)
        
        // Insert items to the database and get back their IDs.
        try await scheduleStore.insert(schedule)
        try await blockItemStore.insert(blockItem)
        
        // Fetch schedules by name.
        let fetchedSchedule = try await scheduleStore.fetch(descriptor: FetchDescriptor<Schedule>(predicate: #Predicate {
            $0.name == customName
        }))
        
        // Fetch block items by name.
        let fetchedBlockItem = try await blockItemStore.fetch(descriptor: FetchDescriptor<BlockItem>(predicate: #Predicate {
            $0.name == customName
        }))
        
        // Evaluate.
        #expect(
            fetchedSchedule.count == 1
            && fetchedBlockItem.count == 1
        )
    }
    
}
