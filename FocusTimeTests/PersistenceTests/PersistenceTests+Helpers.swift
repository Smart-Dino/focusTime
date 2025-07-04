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
    func makeProtectedTestBlockItem(name: String = UUID().uuidString) -> ProtectedBlockItem {
        let selection = FamilyActivitySelection()
        return ProtectedBlockItem(
            emoji: "🔒",
            name: name,
            blockedContent: selection,
            schedulesDescription: "No schedules"
        )
    }
    func makeProtectedTestSchedule(name: String = UUID().uuidString) -> ProtectedSchedule {
        let weekdays: Set<Weekday> = Weekday.weekdays
        let start = TimeComponents(hour: 9, minute: 0)!
        let end = TimeComponents(hour: 17, minute: 0)!
        return ProtectedSchedule(
            emoji: "📅",
            name: name,
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
        scheduleModelID: PersistentIdentifier,
        blockItemModelID: PersistentIdentifier,
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
