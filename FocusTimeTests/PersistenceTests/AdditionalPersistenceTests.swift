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
        let blockItemStore = makeStore()
        // Generate block items.
        let blockItemsToInsert = Array(
            repeating: ProtectedBlockItem(
                emoji: "😜",
                name: "Block",
                days: [.saturday, .sunday],
                type: .scheduled(startTime: .init(hour: 17, minute: 00)!,
                                 endTime: .init(hour: 19, minute: 00)!),
                blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
            ),
            count: eachItemCount
        )
        
        // Batch insert into stores.
        // Important: Use insertBatch for large amounts of data for better performance.
        try await blockItemStore.insertBatch(blockItemsToInsert)
        
        // Evaluate.
        let blockItemCount = try await blockItemStore.fetch().count
        
        #expect(
            blockItemCount == eachItemCount
        )
    }
    
    @Test("Erasing all of the database's data")
    func eraseModel() async throws {
        let blockItemStore = makeStore()
        
        // Make sure contexts are empty.
        try #require(try await blockItemStore.fetch().isEmpty)
        
        // Insert items.
        let _ = try await insertTestItems(blockItemStore: blockItemStore)
        
        // Make sure they are not empty anymore.
        try #require(!(try await blockItemStore.fetch().isEmpty))
        
        // Erase all data.
        try await blockItemStore.eraseAllData()
        
        // Evaluate.
        #expect(try await blockItemStore.fetch().isEmpty)
    }
    
    @Test("Fetching models from database using FetchDescriptor")
    func fetchUsingDescriptor() async throws {
        let blockItemStore = makeStore()
        let customName = "Custom Test Name"
        
        // Generate test items.
        let blockItem = makeProtectedTestBlockItem(name: customName)
        
        // Insert items to the database and get back their IDs.
        try await blockItemStore.insert(blockItem)
        
        // Fetch block items by name.
        let fetchedBlockItem = try await blockItemStore.fetch(descriptor: FetchDescriptor<BlockItem>(predicate: #Predicate {
            $0.name == customName
        }))
        
        // Evaluate.
        #expect(
            fetchedBlockItem.count == 1
        )
    }
    
    @Test("Paging via fetch(page:amountPerPage:)")
    func fetchPaging() async throws {
        let blockItemStore = makeStore()
        let totalCount = 25
        let pageSize = 10

        // Insert block items.
        let blockItemsToInsert = (0..<totalCount).map { i in
            makeProtectedTestBlockItem(name: "BlockItem_\(i)")
        }
        try await blockItemStore.insertBatch(blockItemsToInsert)

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
