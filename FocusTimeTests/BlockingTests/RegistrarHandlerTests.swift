//
//  RegistrarHandlerTests.swift
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

@Suite("Tests related to the DeviceActivityRegistrar && DeviceActivityHandler.", .serialized)
struct RegistrarHandlerTests {
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
    
    init() async {
        // Native managers.
        self.store = ManagedSettingsStore()
        self.center = DeviceActivityCenter()
        
        // Custom.
        let container = SharedTestHelpers.generateTestModelContainer()
        self.shieldManager = LiveShieldManager()
        self.activityHandler = DeviceActivityHandler(container: container, shieldManager: shieldManager)
        
        // Stores.
        self.scheduleStore = ScheduleStore(modelContainer: container)
        self.blockItemStore = BlockItemStore(modelContainer: container)
        // Relationship manager.
        self.relationshipCoordinator = RelationshipCoordinator(modelContainer: container)
        
        self.activityRegistrar = LiveDeviceActivityRegistrar(scheduleStore: scheduleStore, shieldManager: shieldManager)
        
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
                                         type: .scheduled(startTime: startTime, endTime: endTime))
        
        // Insert the schedule and get the new ProtectedSchedule with persistentIdentifier.
        let scheduleModelID = try await scheduleStore.insert(schedule)
        let fetchedSchedule = try await scheduleStore.fetch(id: scheduleModelID)
        
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
        let fetchedSchedule = try await scheduleStore.fetch(id: scheduleModelID)
        
        // Build the activity identifier and name.
        let activityIdentifier = CodableActivityIdentifier(scheduleID: fetchedSchedule.id, isFallback: false)
        let activityIdentifierJSON = try #require(activityIdentifier.jsonString)
        
        let activityName = DeviceActivityName(activityIdentifierJSON)
        
        // Start schedule in the registrar.
        try await activityRegistrar.registerActivity(during: fetchedSchedule)
        
        // Simulate starting the interval.
        await activityHandler.handleBlockingStart(for: activityName)
        
        let isShieldActive = try await shieldManager.isShieldActive
        try #require(isShieldActive)
        
        #expect(
            store.shield.applications == Set<ApplicationToken>() &&
            store.shield.applicationCategories == .specific(categories)
        )
        
        // Simulate ending the interval.
        await activityHandler.handleBlockingEnd(for: activityName)
        
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
                                           blockedContent: ProtectedActivitySelection(selection))
        
        let startTime = try #require(TimeComponents(hour: 17, minute: 00))
        let endTime = try #require(TimeComponents(hour: 18, minute: 00))
        
        let schedule = ProtectedSchedule(emoji: "🧪",
                                         name: "Test",
                                         days: Set(Weekday.allCases),
                                         type: .scheduled(startTime: startTime, endTime: endTime))
        
        // Add items to the database.
        let blockItemModelID = try await blockItemStore.insert(blockItem)
        let scheduleModelID = try await scheduleStore.insert(schedule)
        
        // Add BlockItem to the Schedule.
        try await relationshipCoordinator.relate(blockItemID: blockItemModelID, scheduleID: scheduleModelID)
        
        return scheduleModelID
    }
    
    @Test("Duration-based blocking registration")
    func durationBasedBlocking() async throws {
        // Create a one-time schedule (duration in seconds).
        let duration = 60 // 1 min
        let schedule = ProtectedSchedule(emoji: "⏱️",
                                         name: "DurationTest",
                                         days: Set(Weekday.allCases),
                                         type: .oneTime(.init(duration: duration)))
        // Insert into the store.
        let scheduleModelID = try await scheduleStore.insert(schedule)
        let fetchedSchedule = try await scheduleStore.fetch(id: scheduleModelID)
        
        // Register duration activity.
        try await activityRegistrar.registerActivity(during: fetchedSchedule)
        
        // Fetch the registered schedule.
        let activities = center.activities
        
        // Should be a newly scheduled interval for our test schedule.
        let registeredName = try #require(
            activities.first(where: { $0.rawValue.contains(fetchedSchedule.id.uuidString) })
        )
        let decodedIdentifier = try #require(try CodableActivityIdentifier(from: registeredName))
        #expect(!decodedIdentifier.isFallback)
    }
    
    @Test("Unregistering an individual activity")
    func unregisterIndividualActivity() async throws {
        // Setup and register a schedule.
        let startTime = try #require(TimeComponents(hour: 10, minute: 0))
        let endTime = try #require(TimeComponents(hour: 11, minute: 0))
        
        let schedule = ProtectedSchedule(emoji: "🗑️",
                                         name: "UnregisterTest",
                                         days: Set(Weekday.allCases),
                                         type: .scheduled(startTime: startTime, endTime: endTime))
        
        let scheduleModelID = try await scheduleStore.insert(schedule)
        let fetchedSchedule = try await scheduleStore.fetch(id: scheduleModelID)
        
        try await activityRegistrar.registerActivity(during: fetchedSchedule)
        
        // Confirm registration.
        let preActivities = center.activities
        #expect(preActivities.contains(where: { $0.rawValue.contains(fetchedSchedule.id.uuidString) }))
        
        // Unregister.
        try await activityRegistrar.unregisterActivity(during: fetchedSchedule)
        
        // Confirm removal.
        let postActivities = center.activities
        #expect(!postActivities.contains(where: { $0.rawValue.contains(fetchedSchedule.id.uuidString) }))
    }
    
    @Test("Unregistering all activities")
    func unregisterAllActivities() async throws {
        // Register two schedules.
        let scheduleA = ProtectedSchedule(
            emoji: "🅰️",
            name: "A",
            days: Set(Weekday.allCases),
            type: .scheduled(startTime: .init(hour: 8, minute: 0)!,
                             endTime: .init(hour: 9, minute: 0)!))
        
        let scheduleB = ProtectedSchedule(
            emoji: "🅱️",
            name: "B",
            days: Set(Weekday.allCases),
            type: .scheduled(startTime: .init(hour: 9, minute: 0)!,
                             endTime: .init(hour: 10, minute: 0)!))
        
        let scheduleAID = try await scheduleStore.insert(scheduleA)
        let scheduleBID = try await scheduleStore.insert(scheduleB)
        
        let fetchedA = try await scheduleStore.fetch(id: scheduleAID)
        let fetchedB = try await scheduleStore.fetch(id: scheduleBID)
        
        try await activityRegistrar.registerActivity(during: fetchedA)
        try await activityRegistrar.registerActivity(during: fetchedB)
        
        // Ensure both registered.
        let preActivities = center.activities
        #expect(preActivities.contains(where: { $0.rawValue.contains(fetchedA.id.uuidString) }))
        #expect(preActivities.contains(where: { $0.rawValue.contains(fetchedB.id.uuidString) }))
        // Unregister all.
        await activityRegistrar.unregisterAll()
        // Ensure all removed.
        let postActivities = center.activities
        #expect(postActivities.isEmpty)
    }
    
    @Test("Overlapping schedules should throw scheduleOverlap error")
    func overlappingSchedulesThrowsError() async throws {
        let startTime1 = try #require(TimeComponents(hour: 8, minute: 0))
        let endTime1   = try #require(TimeComponents(hour: 10, minute: 0))
        let startTime2 = try #require(TimeComponents(hour: 9, minute: 0))
        let endTime2   = try #require(TimeComponents(hour: 11, minute: 0)) // Overlaps with previous
        
        // Register the first schedule
        let schedule1 = ProtectedSchedule(emoji: "🔥",
                                          name: "OverlapA",
                                          days: Set(Weekday.allCases),
                                          type: .scheduled(startTime: startTime1, endTime: endTime1))
        let schedule1ID = try await scheduleStore.insert(schedule1)
        let fetchedSchedule1 = try await scheduleStore.fetch(id: schedule1ID)
        try await activityRegistrar.registerActivity(during: fetchedSchedule1)
        
        // Register the second, overlapping schedule
        let schedule2 = ProtectedSchedule(emoji: "💧",
                                          name: "OverlapB",
                                          days: Set(Weekday.allCases),
                                          type: .scheduled(startTime: startTime2, endTime: endTime2))
        let schedule2ID = try await scheduleStore.insert(schedule2)
        let fetchedSchedule2 = try await scheduleStore.fetch(id: schedule2ID)
        
        // Expect scheduleOverlap error
        await #expect {
            try await activityRegistrar.registerActivity(during: fetchedSchedule2)
        } throws: { error in
            guard let error = error as? DeviceActivityRegistrarError else {
                return false
            }
            
            print(error.localizedDescription)
            if case .scheduleOverlap = error {
                return true
            } else {
                return false
            }
        }
    }
    
    @Test("Suspending an activity")
    func suspendActivityTest() async throws {
        // Setup: Register a duration-based schedule.
        let duration = 90 // seconds
        let schedule = ProtectedSchedule(
            emoji: "⏸️",
            name: "SuspendTest",
            days: Set(Weekday.allCases),
            type: .oneTime(.init(duration: duration))
        )
        let scheduleModelID = try await scheduleStore.insert(schedule)
        let fetchedSchedule = try await scheduleStore.fetch(id: scheduleModelID)
        try await activityRegistrar.registerActivity(during: fetchedSchedule)

        // Confirm the activity is registered.
        #expect(try await activityRegistrar.isActivityRegistered(for: fetchedSchedule))

        // Suspend the activity.
        try await activityRegistrar.suspendActivity(for: fetchedSchedule)
        // After suspension, it should not be registered.
        #expect(try await !activityRegistrar.isActivityRegistered(for: fetchedSchedule))
    }

    @Test("Resuming a suspended activity")
    func resumeActivityTest() async throws {
        // Setup: Register, then suspend a schedule.
        let duration = 120 // seconds
        let schedule = ProtectedSchedule(
            emoji: "▶️",
            name: "ResumeTest",
            days: Set(Weekday.allCases),
            type: .oneTime(.init(duration: duration))
        )
        let scheduleModelID = try await scheduleStore.insert(schedule)
        let fetchedSchedule = try await scheduleStore.fetch(id: scheduleModelID)
        try await activityRegistrar.registerActivity(during: fetchedSchedule)
        try await activityRegistrar.suspendActivity(for: fetchedSchedule)

        // Resume the activity.
        try await activityRegistrar.resumeActivity(for: fetchedSchedule)
        // After resumption, should be registered again.
        #expect(try await activityRegistrar.isActivityRegistered(for: fetchedSchedule))
    }

    @Test("isActivityRegistered returns correct value after registration and unregistration")
    func isActivityRegisteredTest() async throws {
        // Register a schedule.
        let duration = 60 // seconds
        let schedule = ProtectedSchedule(
            emoji: "🔍",
            name: "RegisteredCheck",
            days: Set(Weekday.allCases),
            type: .oneTime(.init(duration: duration))
        )
        let scheduleModelID = try await scheduleStore.insert(schedule)
        let fetchedSchedule = try await scheduleStore.fetch(id: scheduleModelID)
        try await activityRegistrar.registerActivity(during: fetchedSchedule)

        // Should be registered now.
        #expect(try await activityRegistrar.isActivityRegistered(for: fetchedSchedule))

        // Unregister.
        try await activityRegistrar.unregisterActivity(during: fetchedSchedule)

        // Should not be registered anymore.
        #expect(try await !activityRegistrar.isActivityRegistered(for: fetchedSchedule))
    }
    
    @Test("Correct time left after 4 minutes of suspension")
    func suspensionTimeAccounting() async throws {
        let testClock = TestClock(startingAt: Date())
        let registrar = LiveDeviceActivityRegistrar(
            center: DeviceActivityCenter(),
            clock: testClock,
            scheduleStore: scheduleStore,
            shieldManager: shieldManager
        )

        let duration = 600 // 10 minutes
        let schedule = ProtectedSchedule(
            emoji: "⏳",
            name: "TimeTravelTest",
            days: Set(Weekday.allCases),
            type: .oneTime(.init(duration: duration))
        )
        let scheduleModelID = try await scheduleStore.insert(schedule)
        let fetchedSchedule = try await scheduleStore.fetch(id: scheduleModelID)
        try await registrar.registerActivity(during: fetchedSchedule)
        
        // Simulate 4 minutes passing.
        await testClock.advance(by: 4 * 60)
        try await registrar.suspendActivity(for: fetchedSchedule)
        
        // Simulate 4 minutes passing.
        await testClock.advance(by: 4 * 60)
        try await registrar.resumeActivity(for: fetchedSchedule)
        
        // Fetch the schedule from your store and check the updated state.
        let resumedSchedule = try await scheduleStore.fetch(id: scheduleModelID)
        if case let .oneTime(_, _, _, timeLeft) = resumedSchedule.type {
            // The time left should be 10 minutes - 4 minutes = 6 minutes (360 seconds).
            #expect(
                timeLeft.rawValue == 360,
                "Should have 6 minutes left since 4 minutes elapsed and 4 minutes suspension after do not count against timeLeft"
            )
        } else {
            #expect(Bool(false), "Schedule type mismatch")
        }
    }
    
}
