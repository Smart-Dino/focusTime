//
//  RelationshipCoordinatorTests.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 03.07.2025.
//

import Testing
import SwiftData
import Foundation
@testable import FocusTime

extension PersistenceTests {

    @Test("Appending a relationship successfully")
    func appendRelationship() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        let resultItems = try await insertTestItems(scheduleStore: scheduleStore, blockItemStore: blockItemStore)
        
        let blockItemModelID = resultItems.blockItemModelID
        let scheduleModelID = resultItems.scheduleModelID
        
        // Append schedule to block item.
        try await coordinator.relate(blockItemID: blockItemModelID, scheduleID: scheduleModelID)
        
        // Fetch items.
        let context = ModelContext(modelContainer)
        let blockItem = try #require(context.model(for: blockItemModelID) as? BlockItem)
        let schedule = try #require(context.model(for: scheduleModelID) as? Schedule)
        
        // Assert the relationship exists.
        #expect(blockItem.schedules?.contains(where: { $0.id == scheduleModelID }) == true)
        #expect(schedule.blockItems?.contains(where: { $0.id == blockItemModelID }) == true)
    }
    
    @Test("Appending a relationship with items's relationship properties set to nil",
        .disabled("Cannot test this part of functionality because setting relationships to nil just results in empty arrays.")
    )
    func appendRelationshipNil() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        let resultItems = try await insertTestItems(scheduleStore: scheduleStore, blockItemStore: blockItemStore)
        
        let blockItemModelID = resultItems.blockItemModelID
        let scheduleModelID = resultItems.scheduleModelID
        
        // Set relationships to nil.
        let context = ModelContext(modelContainer)
        let blockItem = try #require(context.model(for: blockItemModelID) as? BlockItem)
        let schedule = try #require(context.model(for: scheduleModelID) as? Schedule)
        
        blockItem.schedules = nil
        schedule.blockItems = nil
        
        try #require(blockItem.schedules == nil)
        try #require(schedule.blockItems == nil)
        
        // Append schedule to block item.
        try await coordinator.relate(blockItemID: blockItemModelID, scheduleID: scheduleModelID)
        
        // Assert the relationship exists.
        #expect(blockItem.schedules?.contains(where: { $0.id == scheduleModelID }) == true)
        #expect(schedule.blockItems?.contains(where: { $0.id == blockItemModelID }) == true)
    }

    @Test("Appending the same relationship twice returns alreadyRelated error")
    func appendRelationshipTwiceThrows() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        let resultItems = try await insertTestItems(scheduleStore: scheduleStore, blockItemStore: blockItemStore)
        
        let blockItemModelID = resultItems.blockItemModelID
        let scheduleModelID = resultItems.scheduleModelID
        
        try await coordinator.relate(blockItemID: blockItemModelID, scheduleID: scheduleModelID)
        // Try appending again, should throw.
        await #expect(throws: PersistenceStoreError.alreadyRelated, performing: {
            try await coordinator.relate(blockItemID: blockItemModelID, scheduleID: scheduleModelID)
        })
    }

    @Test("Removes an existing relationship")
    func removeRelationship() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        let resultItems = try await insertTestItems(scheduleStore: scheduleStore, blockItemStore: blockItemStore)
        
        let blockItemModelID = resultItems.blockItemModelID
        let scheduleModelID = resultItems.scheduleModelID
        
        // Add the relationship.
        try await coordinator.relate(blockItemID: blockItemModelID, scheduleID: scheduleModelID)
        
        // Remove the relationship.
        try await coordinator.breakRelationship(blockItemID: blockItemModelID, scheduleID: scheduleModelID)
        
        // Fetch items.
        let context = ModelContext(modelContainer)
        let blockItem = try #require(context.model(for: blockItemModelID) as? BlockItem)
        let schedule = try #require(context.model(for: scheduleModelID) as? Schedule)
        
        // Assert the relationship does not exist.
        #expect(blockItem.schedules?.contains(where: { $0.id == scheduleModelID }) == false)
        #expect(schedule.blockItems?.contains(where: { $0.id == blockItemModelID }) == false)
    }

    @Test("Removing a non-existent relationship does nothing")
    func removeNonexistentRelationship() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        let resultItems = try await insertTestItems(scheduleStore: scheduleStore, blockItemStore: blockItemStore)
        
        let blockItemModelID = resultItems.blockItemModelID
        let scheduleModelID = resultItems.scheduleModelID
        
        // Should not throw if the relationship does not exist.
        try await coordinator.breakRelationship(blockItemID: blockItemModelID, scheduleID: scheduleModelID)
    }
    
    @Test("Removing a non-existent relationship with non-existent items")
    func removeNonexistentItemsRelationship() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        let resultItems = try await insertTestItems(scheduleStore: scheduleStore, blockItemStore: blockItemStore)
        
        let blockItemModelID = resultItems.blockItemModelID
        let scheduleModelID = resultItems.scheduleModelID
        
        // Remove block item so it does not exist anymore.
        try await blockItemStore.delete(id: blockItemModelID)
        
        // Should throw PersistenceStoreError.notFound if item does not exist.
        await #expect(throws: PersistenceStoreError.notFound, performing: {
            try await coordinator.breakRelationship(blockItemID: blockItemModelID, scheduleID: scheduleModelID)
        })
        
        // Try with schedule now.
        let resultItems2 = try await insertTestItems(scheduleStore: scheduleStore, blockItemStore: blockItemStore)
        
        let blockItemModelID2 = resultItems2.blockItemModelID
        let scheduleModelID2 = resultItems2.scheduleModelID
        
        // Remove schedule item so it does not exist anymore.
        try await scheduleStore.delete(id: scheduleModelID2)
        
        // Should throw PersistenceStoreError.notFound if item does not exist.
        await #expect(throws: PersistenceStoreError.notFound, performing: {
            try await coordinator.breakRelationship(blockItemID: blockItemModelID2, scheduleID: scheduleModelID2)
        })
    }

    @Test("Appending with non-existent items returns notFound error")
    func appendWithNonexistentItemsThrows() async throws {
        let (scheduleStore, blockItemStore) = makeStores()
        let resultItems = try await insertTestItems(scheduleStore: scheduleStore, blockItemStore: blockItemStore)
        
        let blockItemModelID = resultItems.blockItemModelID
        let scheduleModelID = resultItems.scheduleModelID

        // Delete blockItem and schedule to create non-existent IDs
        try await blockItemStore.delete(id: blockItemModelID)
        try await scheduleStore.delete(id: scheduleModelID)

        // Using deleted items.
        await #expect(throws: PersistenceStoreError.notFound, performing: {
            try await coordinator.relate(blockItemID: blockItemModelID, scheduleID: scheduleModelID)
        })
        
        // Using deleted scheduleID with a new blockItem.
        let resultItems2 = try await insertTestItems(scheduleStore: scheduleStore, blockItemStore: blockItemStore)
        let blockItemModelID2 = resultItems2.blockItemModelID
        
        // Evaluate.
        await #expect(throws: PersistenceStoreError.notFound, performing: {
            try await coordinator.relate(blockItemID: blockItemModelID2, scheduleID: scheduleModelID)
        })
    }
}
