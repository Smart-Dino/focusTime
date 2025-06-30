//
//  BlockManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 24.06.2025.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

@MainActor
protocol ShieldManager {
    // MARK: - Properties
    var isShieldActive: Bool { get }
    var monitoredIdentifiers: Set<UUID> { get }
    // MARK: - Block
    func block() async throws
    func block(specific selection: FamilyActivitySelection) async throws
    func block(specific selection: FamilyActivitySelection, schedule: Schedule) async throws
    // MARK: - Unblock
    func unblock() async throws
    // MARK: - Auth
    func checkAuthorization() async throws
}

@MainActor
@Observable
final class LiveShieldManager: ShieldManager {
    private let store: ManagedSettingsStore
    private let center: DeviceActivityCenter
    
    private(set) var isShieldActive: Bool = false
    var monitoredIdentifiers: Set<UUID> {
        Set(center.activities.compactMap {
            let uuidString = $0.rawValue.components(separatedBy: .whitespaces)[0]
            return UUID(uuidString: uuidString)
        })
    }
    
    init() {
        let store = ManagedSettingsStore()
        let center = DeviceActivityCenter()
        self.store = store
        self.center = center
        updateShieldStatus()
    }
    
    func block() async throws {
        try await checkAuthorization()
        defer { updateShieldStatus() }
        
        store.shield.applicationCategories = .all()
    }
    
    func block(specific selection: FamilyActivitySelection) async throws {
        try await checkAuthorization()
        defer { updateShieldStatus() }
        
        let applicationsToDiscourage = selection.applicationTokens
        
        // Block selected applications.
        if applicationsToDiscourage.isEmpty {
            store.shield.applications = nil
        } else {
            store.shield.applications = applicationsToDiscourage
        }
        
        let applicationCategoriesToDiscourage = selection.categoryTokens
        
        // Block selected categories.
        if applicationCategoriesToDiscourage.isEmpty {
            store.shield.applicationCategories = nil
        } else {
            store.shield.applicationCategories = .specific(applicationCategoriesToDiscourage)
        }
    }
    
    // The reason why we schedule two schedules instead of one
    // is because if the user wants an interval to be less than 15 minutes
    // - the system will not allow us to do so and throw an error.
    // We can solve this by having two separate schedules that are both 15+
    // mins in length but have less than 15 minutes in-between them!
    func block(specific selection: FamilyActivitySelection, schedule: Schedule) async throws {
        // Start of interval + 15 mins.
        let intervalStart = schedule.startTime.dateComponents
        let startAddingFifteen = intervalStart.adding(minutes: 15)
        
        // End of interval + 15 mins.
        let intervalEnd = schedule.endTime.dateComponents
        let endAddingFifteen = intervalEnd.adding(minutes: 15)
        
        // Generate ids for querying DB.
        let deviceActivityStartName = DeviceActivityName(schedule.id.uuidString + " " + "start")
        let deviceActivityEndName = DeviceActivityName(schedule.id.uuidString + " " + "end")
        
        // Schedule both events.
        let deviceActivityScheduleStart = DeviceActivitySchedule(intervalStart: intervalStart,
                                                            intervalEnd: startAddingFifteen,
                                                            repeats: true)
        
        let deviceActivityScheduleEnd = DeviceActivitySchedule(intervalStart: intervalEnd,
                                                            intervalEnd: endAddingFifteen,
                                                            repeats: true)
        
        // Start monitoring events.
        try center.startMonitoring(deviceActivityStartName, during: deviceActivityScheduleStart)
        try center.startMonitoring(deviceActivityEndName, during: deviceActivityScheduleEnd)
    }
    
    func unblock() async throws {
        try await checkAuthorization()
        defer { updateShieldStatus() }
        
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
    
    func updateShieldStatus() {
        isShieldActive = store.shield.applications != nil || store.shield.applicationCategories != nil
    }
    
    func checkAuthorization() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }
}
