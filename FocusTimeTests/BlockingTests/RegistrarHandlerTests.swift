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
    let blockItemStore: BlockItemStore
    let container: ModelContainer
    
    init() async {
        // Native managers.
        self.store = ManagedSettingsStore()
        self.center = DeviceActivityCenter()
        
        // Custom.
        let container = SharedTestHelpers.generateTestModelContainer()
        self.container = container
        self.shieldManager = LiveShieldManager()
        self.activityHandler = DeviceActivityHandler(logger: nil, container: container, shieldManager: shieldManager)
        
        // Stores.
        self.blockItemStore = BlockItemStore(modelContainer: container)
        //  Activity registrar.
        self.activityRegistrar = LiveDeviceActivityRegistrar(modelContainer: container, shieldManager: shieldManager)
        
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
        let startTime = try TimeComponents(hour: startHour, minute: startMinute)
        let endTime = try TimeComponents(hour: endHour, minute: endMinute)
        // Setup.
        let blockItem = ProtectedBlockItem(
            emoji: "🧪",
            name: "Test",
            days: Set(Weekday.allCases),
            type: .scheduled(startTime: startTime, endTime: endTime),
            blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
        )
        
        // Insert the schedule and get the new ProtectedSchedule with persistentIdentifier.
        let blockItemModelID = try await blockItemStore.insert(blockItem)
        let fetchedBlockItem = try await blockItemStore.fetch(id: blockItemModelID)
        
        // Register the activity.
        try await activityRegistrar.registerActivity(during: fetchedBlockItem)
        
        // Fetch the registered schedule.
        let activities = center.activities
        
        let registeredScheduleName = try #require(
            activities.first(where: { $0.rawValue.contains(fetchedBlockItem.id.uuidString) })
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
        let blockItemModelID = try await insertTestBlockItem(with: selection)
        
        // Fetch schedule model.
        let fetchedBlockItem = try await blockItemStore.fetch(id: blockItemModelID)
        
        // Build the activity identifier and name.
        let activityIdentifier = CodableActivityIdentifier(blockItemID: fetchedBlockItem.id, isFallback: false)
        let activityIdentifierJSON = try #require(activityIdentifier.jsonString)
        
        let activityName = DeviceActivityName(activityIdentifierJSON)
        
        // Start schedule in the registrar.
        try await activityRegistrar.registerActivity(during: fetchedBlockItem)
        
        // Simulate starting the interval.
        await activityHandler.handleBlockingStart(for: activityName)
        
        let isShieldActive = try await shieldManager.isShieldActive
        try #require(isShieldActive)
        
        #expect(
            store.shield.applications == Set<ApplicationToken>() &&
            store.shield.applicationCategories == .specific(categories)
        )
        
        // Simulate ending the interval.
        await activityHandler.handleBlockingEnd()
        
        #expect(
            store.shield.applications == nil &&
            store.shield.applicationCategories == nil
        )
    }
    
    func insertTestBlockItem(
        with selection: FamilyActivitySelection
    ) async throws -> PersistentIdentifier {
        // Make protected items.
        let blockItem = ProtectedBlockItem(emoji: "🧪",
                                           name: "Test",
                                           blockedContent: ProtectedActivitySelection(selection))
        
        let startTime = try TimeComponents(hour: 17, minute: 00)
        let endTime = try TimeComponents(hour: 18, minute: 00)
        
        let blockItem = ProtectedBlockItem(emoji: "🧪",
                                           name: "Test",
                                           days: Set(Weekday.allCases),
                                           type: .scheduled(startTime: startTime, endTime: endTime),
                                           blockedContent: ProtectedActivitySelection(selection))
        
        // Add items to the database.
        let blockItemModelID = try await blockItemStore.insert(blockItem)
        
        // Return identifier.
        return blockItemModelID
    }
    
    @Test("Duration-based blocking registration")
    func durationBasedBlocking() async throws {
        // Create a one-time schedule (duration in seconds).
        let duration = 60 // 1 min
        let blockItem = ProtectedBlockItem(emoji: "⏱️",
                                           name: "DurationTest",
                                           days: Set(Weekday.allCases),
                                           type: ScheduleType.oneTime(.init(duration: duration)),
                                           blockedContent: ProtectedActivitySelection(FamilyActivitySelection()))
        // Insert into the store.
        let blockItemModelID = try await blockItemStore.insert(blockItem)
        let fetchedBlockedItem = try await blockItemStore.fetch(id: blockItemModelID)
        
        // Register duration activity.
        try await activityRegistrar.registerActivity(during: fetchedBlockedItem)
        
        // Fetch the registered schedule.
        let activities = center.activities
        
        // Should be a newly scheduled interval for our test schedule.
        let registeredName = try #require(
            activities.first(where: { $0.rawValue.contains(fetchedBlockedItem.id.uuidString) })
        )
        let decodedIdentifier = try #require(try CodableActivityIdentifier(from: registeredName))
        #expect(!decodedIdentifier.isFallback)
    }
    
    @Test("Unregistering an individual activity")
    func unregisterIndividualActivity() async throws {
        // Setup and register a schedule.
        let startTime = try TimeComponents(hour: 10, minute: 0)
        let endTime = try TimeComponents(hour: 11, minute: 0)
        
        let blockItem = ProtectedBlockItem(emoji: "🗑️",
                                           name: "UnregisterTest",
                                           days: Set(Weekday.allCases),
                                           type: ScheduleType.scheduled(startTime: startTime, endTime: endTime),
                                           blockedContent: ProtectedActivitySelection(FamilyActivitySelection()))
        
        let blockItemModelID = try await blockItemStore.insert(blockItem)
        let fetchedBlockItem = try await blockItemStore.fetch(id: blockItemModelID)
        
        try await activityRegistrar.registerActivity(during: fetchedBlockItem)
        
        // Confirm registration.
        let preActivities = center.activities
        #expect(preActivities.contains(where: { $0.rawValue.contains(fetchedBlockItem.id.uuidString) }))
        
        // Unregister.
        try await activityRegistrar.unregisterActivity(during: fetchedBlockItem)
        
        // Confirm removal.
        let postActivities = center.activities
        #expect(!postActivities.contains(where: { $0.rawValue.contains(fetchedBlockItem.id.uuidString) }))
    }
    
    @Test("Unregistering all activities")
    func unregisterAllActivities() async throws {
        // Register two schedules.
        let startTimeA = try TimeComponents(hour: 8, minute: 0)
        let endTimeA = try TimeComponents(hour: 9, minute: 0)
        
        let blockItemA = ProtectedBlockItem(
            emoji: "🅰️",
            name: "A",
            days: Set(Weekday.allCases),
            type: .scheduled(startTime: startTimeA,
                             endTime: endTimeA),
            blockedContent: ProtectedActivitySelection(FamilyActivitySelection()))
        
        let startTimeB = try TimeComponents(hour: 9, minute: 0)
        let endTimeB = try TimeComponents(hour: 10, minute: 0)
        
        let blockItemB = ProtectedBlockItem(
            emoji: "🅱️",
            name: "B",
            days: Set(Weekday.allCases),
            type: .scheduled(startTime: startTimeB,
                             endTime: endTimeB),
            blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
        )
        
        let blockItemAID = try await blockItemStore.insert(blockItemA)
        let blockItemBID = try await blockItemStore.insert(blockItemB)
        
        let fetchedA = try await blockItemStore.fetch(id: blockItemAID)
        let fetchedB = try await blockItemStore.fetch(id: blockItemBID)
        
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
        let startTime1 = try TimeComponents(hour: 8, minute: 0)
        let endTime1   = try TimeComponents(hour: 10, minute: 0)
        let startTime2 = try TimeComponents(hour: 9, minute: 0)
        let endTime2   = try TimeComponents(hour: 11, minute: 0) // Overlaps with previous
        
        // Register the first schedule
        let blockItem1 = ProtectedBlockItem(emoji: "🔥",
                                          name: "OverlapA",
                                          days: Set(Weekday.allCases),
                                          type: ScheduleType.scheduled(startTime: startTime1, endTime: endTime1),
                                          blockedContent: ProtectedActivitySelection(FamilyActivitySelection()))
        let blockItem1ID = try await blockItemStore.insert(blockItem1)
        let fetchedBlockItem1 = try await blockItemStore.fetch(id: blockItem1ID)
        try await activityRegistrar.registerActivity(during: fetchedBlockItem1)
        
        // Register the second, overlapping schedule
        let blockItem2 = ProtectedBlockItem(emoji: "💧",
                                          name: "OverlapB",
                                          days: Set(Weekday.allCases),
                                          type: ScheduleType.scheduled(startTime: startTime2, endTime: endTime2),
                                          blockedContent: ProtectedActivitySelection(FamilyActivitySelection()))
        let blockItem2ID = try await blockItemStore.insert(blockItem2)
        let fetchedBlockItem2 = try await blockItemStore.fetch(id: blockItem2ID)
        
        // Expect scheduleOverlap error
        await #expect {
            try await activityRegistrar.registerActivity(during: fetchedBlockItem2)
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
        let blockItem = ProtectedBlockItem(
            emoji: "⏸️",
            name: "SuspendTest",
            days: Set(Weekday.allCases),
            type: ScheduleType.oneTime(.init(duration: duration)),
            blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
        )
        let blockItemModelID = try await blockItemStore.insert(blockItem)
        let fetchedBlockItem = try await blockItemStore.fetch(id: blockItemModelID)
        try await activityRegistrar.registerActivity(during: fetchedBlockItem)

        // Confirm the activity is registered.
        #expect(try await activityRegistrar.isActivityRegistered(for: fetchedBlockItem))

        // Suspend the activity.
        try await activityRegistrar.suspendActivity(for: fetchedBlockItem)
        // After suspension, it should not be registered.
        #expect(try await !activityRegistrar.isActivityRegistered(for: fetchedBlockItem))
    }

    @Test("Resuming a suspended activity")
    func resumeActivityTest() async throws {
        // Setup: Register, then suspend a schedule.
        let duration = 120 // seconds
        let blockItem = ProtectedBlockItem(
            emoji: "▶️",
            name: "ResumeTest",
            days: Set(Weekday.allCases),
            type: ScheduleType.oneTime(.init(duration: duration)),
            blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
        )
        let blockItemModelID = try await blockItemStore.insert(blockItem)
        let fetchedBlockItem = try await blockItemStore.fetch(id: blockItemModelID)
        
        try await activityRegistrar.registerActivity(during: fetchedBlockItem)
        try await activityRegistrar.suspendActivity(for: fetchedBlockItem)

        // Resume the activity.
        try await activityRegistrar.resumeActivity(for: fetchedBlockItem)
        // After resumption, should be registered again.
        #expect(try await activityRegistrar.isActivityRegistered(for: fetchedBlockItem))
    }

    @Test("isActivityRegistered returns correct value after registration and unregistration")
    func isActivityRegisteredTest() async throws {
        // Register a schedule.
        let duration = 60 // seconds
        let blockItem = ProtectedBlockItem(
            emoji: "🔍",
            name: "RegisteredCheck",
            days: Set(Weekday.allCases),
            type: ScheduleType.oneTime(.init(duration: duration)),
            blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
        )
        let blockItemModelID = try await blockItemStore.insert(blockItem)
        let fetchedBlockItem = try await blockItemStore.fetch(id: blockItemModelID)
        try await activityRegistrar.registerActivity(during: fetchedBlockItem)

        // Should be registered now.
        #expect(try await activityRegistrar.isActivityRegistered(for: fetchedBlockItem))

        // Unregister.
        try await activityRegistrar.unregisterActivity(during: fetchedBlockItem)

        // Should not be registered anymore.
        #expect(try await !activityRegistrar.isActivityRegistered(for: fetchedBlockItem))
    }
    
    @Test("Correct time left after 4 minutes of suspension")
    func suspensionTimeAccounting() async throws {
        let testClock = TestClock(startingAt: Date())
        let registrar = LiveDeviceActivityRegistrar(
            center: DeviceActivityCenter(),
            clock: testClock,
            modelContainer: container,
            shieldManager: shieldManager
        )

        let duration = 600 // 10 minutes
        let blockItem = ProtectedBlockItem(
            emoji: "⏳",
            name: "TimeTravelTest",
            days: Set(Weekday.allCases),
            type: ScheduleType.oneTime(.init(duration: duration)),
            blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
        )
        let blockItemModelID = try await blockItemStore.insert(blockItem)
        let fetchedBlockItem = try await blockItemStore.fetch(id: blockItemModelID)
        try await registrar.registerActivity(during: fetchedBlockItem)
        
        // Simulate 4 minutes passing.
        await testClock.advance(by: 4 * 60)
        try await registrar.suspendActivity(for: fetchedBlockItem)
        
        // Simulate 4 minutes passing.
        await testClock.advance(by: 4 * 60)
        try await registrar.resumeActivity(for: fetchedBlockItem)
        
        // Fetch the schedule from your store and check the updated state.
        let resumedBlockItem = try await blockItemStore.fetch(id: blockItemModelID)
        if case let ScheduleType.oneTime(_, _, _, timeLeft) = resumedBlockItem.type {
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

