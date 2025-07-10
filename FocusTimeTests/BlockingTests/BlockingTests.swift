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
        self.activityHandler = DeviceActivityHandler(container: container)
        
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
            (17, 0, 21, 0),
            (13, 0, 14, 0),
            (13, 25, 13, 30),
            (11, 11, 11, 12),
            (0, 0, 1, 0),
            (15, 0, 14, 0)
          ])
    func scheduledBlocking(startHour: Int, startMinute: Int, endHour: Int, endMinute: Int) async throws {
        let startTime = try #require(TimeComponents(hour: startHour, minute: startMinute))
        let endTime = try #require(TimeComponents(hour: endHour, minute: endMinute))
        // Setup.
        let schedule = ProtectedSchedule(emoji: "🧪",
                                         name: "Test",
                                         days: Set(Weekday.allCases),
                                         startTime: startTime,
                                         endTime: endTime)
        
        // Insert the schedule and get the new ProtectedSchedule with persistentIdentifier.
        let scheduleModelID = try await scheduleStore.insert(schedule)
        let fetchedSchedule = try #require(try await scheduleStore.fetch(id: scheduleModelID))
        
        // Register the activity.
        try await activityRegistrar.registerActivity(during: fetchedSchedule)
        
        // Fetch the registered schedule.
        let activities = center.activities
        
        let registeredScheduleName = try #require(
            activities.first(where: { $0.rawValue.contains(fetchedSchedule.id.uuidString) })
        )
        
        // Decide the identifier to check whether it was scheduled with fallback.
        let decodedIdentifier = try #require(try CodableActivityIdentifier(from: registeredScheduleName))
        let wasScheduledWithFallback = decodedIdentifier.isFallback
        
        let registeredSchedule = try #require(
            center.schedule(for: registeredScheduleName)
        )
        
        if !wasScheduledWithFallback {
            #expect(registeredSchedule.intervalStart == startTime.dateComponents &&
                    registeredSchedule.intervalEnd == endTime.dateComponents)
        } else {
            // In case of fallback the intervalEnd is usually shifted 15 minutes, so we don't check that.
            #expect(registeredSchedule.intervalStart == startTime.dateComponents)
        }
    }
    
    @Test("Testing blocking from a database item.", .tags(.persistenceStore))
    func blockFromDatabase() async throws {
        // Setup selection.
        let applications = Set<ApplicationToken>()
        let categories = Set<ActivityCategoryToken>()

        var selection = FamilyActivitySelection()
        selection.applicationTokens = applications
        selection.categoryTokens = categories

        // Create a schedule with selection.
        let scheduleModelID = try await insertTestScheduleRelatedToBlockItem(with: selection)

        // Fetch schedule model.
        let fetchedSchedule = try #require(try await scheduleStore.fetch(id: scheduleModelID))

        // Build the activity identifier and name.
        let activityIdentifier = CodableActivityIdentifier(scheduleID: fetchedSchedule.id, isFallback: false)
        let activityIdentifierJSON = try #require(activityIdentifier.jsonString)
        
        let activityName = DeviceActivityName(activityIdentifierJSON)

        // Start schedule in the registrar.
        try await activityRegistrar.registerActivity(during: fetchedSchedule)

        // Simulate starting the interval.
        activityHandler.handleBlockingStart(for: activityName)

        try #require(shieldManager.isShieldActive)

        #expect(
            store.shield.applications == Set<ApplicationToken>() &&
            store.shield.applicationCategories == .specific(categories)
        )

        // Simulate ending the interval.
        activityHandler.handleBlockingEnd(for: activityName)

        #expect(
            store.shield.applications == nil &&
            store.shield.applicationCategories == nil
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
