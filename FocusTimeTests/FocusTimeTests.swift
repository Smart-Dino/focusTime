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
        
        let allCategories = ShieldSettings.ActivityCategoryPolicy<Application>.all()
        
        #expect(store.shield.applicationCategories == allCategories)
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
        try #require(shieldManager.isShieldActive)
        
        var startSchedule = center.schedule(for: DeviceActivityName(rawValue: uuid.uuidString + " start"))
        var endSchedule = center.schedule(for: DeviceActivityName(rawValue: uuid.uuidString + " end"))
        
        let startComponents = try #require(startSchedule.take()?.intervalStart)
        let endComponents = try #require(endSchedule.take()?.intervalStart)
        
        #expect(
            startTime.dateComponents == startComponents
            && endTime.dateComponents == endComponents
        )
    }
    
}
