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
        let startTime = try TimeComponents(hour: 17, minute: 00)
        let endTime = try TimeComponents(hour: 19, minute: 00)
        let schedulesToInsert = Array(
            repeating: ProtectedSchedule(
                emoji: "🏠",
                name: "Spend time with family",
                days: [.saturday, .sunday],
                type: .scheduled(startTime: startTime,
                                 endTime: endTime)
            ),
            count: eachItemCount
        )
        // Generate block items.
        let blockItemsToInsert = Array(
            repeating: ProtectedBlockItem(
                emoji: "😜",
                name: "Block",
                blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
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
        let schedule = try makeProtectedTestSchedule(name: customName)
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
    
    @Test("Paging via fetch(page:amountPerPage:)")
    func fetchPaging() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        let totalCount = 25
        let pageSize = 10

        // Insert schedules.
        let schedulesToInsert = try (0..<totalCount).map { i in
            try makeProtectedTestSchedule(name: "Schedule_\(i)")
        }
        try await scheduleStore.insertBatch(schedulesToInsert)

        // Insert block items.
        let blockItemsToInsert = (0..<totalCount).map { i in
            makeProtectedTestBlockItem(name: "BlockItem_\(i)")
        }
        try await blockItemStore.insertBatch(blockItemsToInsert)

        // Test paging for schedules.
        let firstPage = try await scheduleStore.fetch(page: 0, amountPerPage: pageSize)
        let secondPage = try await scheduleStore.fetch(page: 1, amountPerPage: pageSize)
        let thirdPage = try await scheduleStore.fetch(page: 2, amountPerPage: pageSize)

        #expect(firstPage.count == 10)
        #expect(secondPage.count == 10)
        #expect(thirdPage.count == 5)
        withKnownIssue("Relational databases do not hold the sequence of the items in which they were added.") {
            #expect(firstPage[0].name == "Schedule_0")
            #expect(secondPage[0].name == "Schedule_10")
            #expect(thirdPage[0].name == "Schedule_20")
        }

        // Test paging for block items.
        let firstBlockPage = try await blockItemStore.fetch(page: 0, amountPerPage: pageSize)
        let secondBlockPage = try await blockItemStore.fetch(page: 1, amountPerPage: pageSize)
        let thirdBlockPage = try await blockItemStore.fetch(page: 2, amountPerPage: pageSize)

        #expect(firstBlockPage.count == 10)
        #expect(secondBlockPage.count == 10)
        #expect(thirdBlockPage.count == 5)
        withKnownIssue("Relational databases do not hold the sequence of the items in which they were added.") {
            #expect(firstBlockPage[0].name == "BlockItem_0")
            #expect(secondBlockPage[0].name == "BlockItem_10")
            #expect(thirdBlockPage[0].name == "BlockItem_20")
        }
    }
    
}
