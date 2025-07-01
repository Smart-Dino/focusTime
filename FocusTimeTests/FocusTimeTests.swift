//
//  FocusTimeTests.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 01.07.2025.
//

import Testing
import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls
@testable import FocusTime

@MainActor
@Suite("Tests related to the app blocking.")
struct Blocking {
    // MARK: Native Managers
    let store = ManagedSettingsStore()
    let center = DeviceActivityCenter()
    // MARK: Custom Managers
    let shieldManager = LiveShieldManager()
    // Stores
    let scheduleStore = ScheduleStore()
    let blockItemStore = BlockItemStore()
    // MARK: Reused declarations
    let allCategories = ShieldSettings.ActivityCategoryPolicy<Application>.all()
    
    init() {
        center.stopMonitoring()
        
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
        store.shield.webDomainCategories = nil
    }
    
    @Test("Basic block of all applications.")
    func blockingAllApplications() async throws {
        try await shieldManager.block()
        
        #expect(store.shield.applicationCategories == allCategories)
    }
    
    @Test("Unblocking all applications.")
    func unblockAllApplications() async throws {
        try await shieldManager.block()
        try #require(shieldManager.isShieldActive)
        
        try await shieldManager.unblock()
        #expect(!shieldManager.isShieldActive && store.shield.applicationCategories == nil)
    }
    
    @Test("Scheduled blocking.", .disabled(),
          arguments: [
            (TimeComponents(hour: 17, minute: 00)!, TimeComponents(hour: 21, minute: 00)!),
            (TimeComponents(hour: 13, minute: 00)!, TimeComponents(hour: 14, minute: 00)!),
            (TimeComponents(hour: 13, minute: 25)!, TimeComponents(hour: 13, minute: 30)!),
            (TimeComponents(hour: 11, minute: 11)!, TimeComponents(hour: 11, minute: 12)!),
            (TimeComponents(hour: 00, minute: 00)!, TimeComponents(hour: 01, minute: 00)!),
            (TimeComponents(hour: 15, minute: 00)!, TimeComponents(hour: 14, minute: 00)!)
          ])
    func scheduledBlocking(startTime: TimeComponents, endTime: TimeComponents) async throws {
        let uuid = UUID()
        // Setup.
        let schedule = Schedule(id: uuid,
                                emoji: "🧪",
                                name: "Test",
                                days: Weekday.weekends,
                                startTime: startTime,
                                endTime: endTime)
        
        try await shieldManager.block(during: schedule)
        // Evaluate.
        withKnownIssue("Whether the shield is active is determined by whether we have any tokens in blockage. For now I do not add any BlockItems to the Schedule so it returns false, obviously.") {
            try #require(shieldManager.isShieldActive)
        }
        
        var startSchedule = center.schedule(for: DeviceActivityName(rawValue: uuid.uuidString + " start"))
        var endSchedule = center.schedule(for: DeviceActivityName(rawValue: uuid.uuidString + " end"))
        
        let startComponents = try #require(startSchedule.take()?.intervalStart)
        let endComponents = try #require(endSchedule.take()?.intervalStart)
        
        #expect(
            startTime.dateComponents == startComponents
            && endTime.dateComponents == endComponents
        )
    }
    
    @Test("Testing blocking from a database item.", .tags(.persistenceStore))
    func blockFromDatabase() async throws {
        // Setup.
        let applications = Set<ApplicationToken>() // Cannot add any tokens here...
        let categories = Set<ActivityCategoryToken>() // Cannot add any tokens here...
        
        var selection = FamilyActivitySelection()
        selection.applicationTokens = applications
        selection.categoryTokens = categories
        
        // Make protected items.
        let blockItem = ProtectedBlockItem(emoji: "🧪",
                                           name: "Test",
                                           blockedContent: selection)
        
        let startTime = try #require(TimeComponents(hour: 17, minute: 00))
        let endTime = try #require(TimeComponents(hour: 18, minute: 00))
        
        let schedule = ProtectedSchedule(emoji: "🧪",
                                         name: "Test",
                                         days: Weekday.weekdays,
                                         startTime: startTime,
                                         endTime: endTime)
        
        // Add items to the database.
        try await blockItemStore.insert(blockItem)
        try await scheduleStore.insert(schedule)
        
        // Fetch items from database.
        
        let blockModel = try #require(try blockItemStore.fetch(id: blockItem.id))
        let scheduleModel = try #require(try scheduleStore.fetch(id: schedule.id))
        
        // Add BlockItem to the Schedule.
        withKnownIssue("This will not work because both stores have different ModelContainers.") {
            scheduleModel.appendBlockItem(blockModel)
        }
        
        // Start schedule.
        try await shieldManager.block(during: scheduleModel)
        
        // Evaluate.
        #expect(
            store.shield.applications == applications
            && store.shield.applicationCategories == .specific(categories)
        )
        
        var startSchedule = center.schedule(for: DeviceActivityName(rawValue: scheduleModel.id.uuidString + " start"))
        var endSchedule = center.schedule(for: DeviceActivityName(rawValue: scheduleModel.id.uuidString + " end"))
        
        let startComponents = try #require(startSchedule.take()?.intervalStart)
        let endComponents = try #require(endSchedule.take()?.intervalStart)
        
        #expect(
            startTime.dateComponents == startComponents
            && endTime.dateComponents == endComponents
        )
    }
    
}
