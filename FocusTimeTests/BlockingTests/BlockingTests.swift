//
//  FocusTimeTests.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 01.07.2025.
//

import Testing
import SwiftData
import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls
@testable import FocusTime

@MainActor
@Suite("Tests related to the app blocking.")
struct BlockingTests {
    // MARK: Native Managers
    let store: ManagedSettingsStore
    let center: DeviceActivityCenter
    // MARK: Custom Managers
    let shieldManager: ShieldManager
    let activityRegistrar: DeviceActivityRegistrar
    let activityHandler: DeviceActivityHandler
    // Stores.
    let scheduleStore: ScheduleStore
    let blockItemStore: BlockItemStore
    // Relationship manager.
    let relationshipCoordinator: RelationshipCoordinator
    // MARK: Reused declarations
    let allCategories = ShieldSettings.ActivityCategoryPolicy<Application>.all()
    
    init() {
        // Native managers.
        self.store = ManagedSettingsStore()
        self.center = DeviceActivityCenter()
        
        // Custom.
        let container = SharedTestHelpers.generateTestModelContainer()
        self.shieldManager = LiveShieldManager()
        self.activityRegistrar = LiveDeviceActivityRegistrar(center: center)
        self.activityHandler = DeviceActivityHandler(store: store, container: container)
        
        // Stores.
        self.scheduleStore = ScheduleStore(modelContainer: container)
        self.blockItemStore = BlockItemStore(modelContainer: container)
        // Relationship manager.
        self.relationshipCoordinator = RelationshipCoordinator(modelContainer: container)
        
        // Reset.
        resetDeviceActivityCenter()
        resetManagedSettingsStore()
    }
    
    func resetDeviceActivityCenter() {
        center.stopMonitoring()
    }
    
    func resetManagedSettingsStore() {
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
    
    @Test("Scheduled blocking.",
          arguments: [
            (TimeComponents(hour: 17, minute: 00)!, TimeComponents(hour: 21, minute: 00)!),
            (TimeComponents(hour: 13, minute: 00)!, TimeComponents(hour: 14, minute: 00)!),
            (TimeComponents(hour: 13, minute: 25)!, TimeComponents(hour: 13, minute: 30)!),
            (TimeComponents(hour: 11, minute: 11)!, TimeComponents(hour: 11, minute: 12)!),
            (TimeComponents(hour: 00, minute: 00)!, TimeComponents(hour: 01, minute: 00)!),
            (TimeComponents(hour: 15, minute: 00)!, TimeComponents(hour: 14, minute: 00)!)
          ])
    func scheduledBlocking(startTime: TimeComponents, endTime: TimeComponents) async throws {
        // Setup.
        let schedule = ProtectedSchedule(emoji: "🧪",
                                         name: "Test",
                                         days: Set(Weekday.allCases),
                                         startTime: startTime,
                                         endTime: endTime)
        
        // Insert the schedule and get the new ProtectedSchedule with persistentIdentifier.
        let scheduleModelID = try await scheduleStore.insert(schedule)
        let fetchedSchedule = try #require(try await scheduleStore.fetch(id: scheduleModelID))
        
        try await activityRegistrar.registerActivity(during: fetchedSchedule)
        // Evaluate.
        let startSchedule = try #require(center.schedule(for: DeviceActivityName(rawValue: fetchedSchedule.id.uuidString + " start")))
        let endSchedule = try #require(center.schedule(for: DeviceActivityName(rawValue: fetchedSchedule.id.uuidString + " end")))
        
        let startComponents = startSchedule.intervalStart
        let endComponents = endSchedule.intervalStart
        
        #expect(
            startTime.dateComponents == startComponents
            && endTime.dateComponents == endComponents
        )
    }
    
    @Test("Testing blocking from a database item.", .tags(.persistenceStore))
    func blockFromDatabase() async throws {
        // Setup selection.
        let applications = Set<ApplicationToken>() // Cannot add any tokens here...
        let categories = Set<ActivityCategoryToken>() // Cannot add any tokens here...
        
        var selection = FamilyActivitySelection()
        selection.applicationTokens = applications
        selection.categoryTokens = categories
        
        // Create a schedule with selection.
        let scheduleModelID = try await insertTestScheduleRelatedToBlockItem(with: selection)
        
        // Fetch schedule model.
        let fetchedSchedule = try #require(try await scheduleStore.fetch(id: scheduleModelID))
        
        // Start schedule.
        try await activityRegistrar.registerActivity(during: fetchedSchedule)
        
        // Simulate starting the start interval.
        let startActivityName = DeviceActivityName(rawValue: fetchedSchedule.id.uuidString + " start")
        activityHandler.handleIntervalStart(for: startActivityName)
        
        try #require(shieldManager.isShieldActive)
        
        #expect(
            store.shield.applications == Set<ApplicationToken>()
            && store.shield.applicationCategories == .specific(categories)
        )
        
        // Simulate starting the end interval.
        let endActivityName = DeviceActivityName(rawValue: fetchedSchedule.id.uuidString + " end")
        activityHandler.handleIntervalStart(for: endActivityName)
        
        #expect(
            store.shield.applications == nil
            && store.shield.applicationCategories == nil
        )
    }
    
    func insertTestScheduleRelatedToBlockItem(
        with selection: FamilyActivitySelection
    ) async throws -> PersistentIdentifier {
        // Make protected items.
        let blockItem = ProtectedBlockItem(emoji: "🧪",
                                           name: "Test",
                                           blockedContent: selection)
        
        let startTime = try #require(TimeComponents(hour: 17, minute: 00))
        let endTime = try #require(TimeComponents(hour: 18, minute: 00))
        
        let schedule = ProtectedSchedule(emoji: "🧪",
                                         name: "Test",
                                         days: Set(Weekday.allCases),
                                         startTime: startTime,
                                         endTime: endTime)
        
        // Add items to the database.
        let blockItemModelID = try await blockItemStore.insert(blockItem)
        let scheduleModelID = try await scheduleStore.insert(schedule)
        
        // Add BlockItem to the Schedule.
        try await relationshipCoordinator.relate(blockItemID: blockItemModelID, scheduleID: scheduleModelID)
        
        return scheduleModelID
    }
    
}
