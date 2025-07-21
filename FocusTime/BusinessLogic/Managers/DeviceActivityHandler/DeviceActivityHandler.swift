//
//  DeviceActivityHandler.swift
//  FocusTimeActivityMonitor
//
//  Created by Maksym Horobets on 04.07.2025.
//

import SwiftData
import Foundation
import DeviceActivity
import FamilyControls
import ManagedSettings

struct DeviceActivityHandler {
    private let container: ModelContainer
    
    init(container: ModelContainer) {
        self.container = container
    }
    
    func handleBlockingStart(for activity: DeviceActivityName) {
        guard let activityIdentifier = try? CodableActivityIdentifier(from: activity) else { return }
        
        let schedule = fetchSchedule(id: activityIdentifier.scheduleID)
        
        // Make sure we have our schedule.
        guard let schedule, let blockItems = schedule.blockItems else { return }
        
        // Make sure the current day is the block day.
        guard schedule.days.contains(Weekday.currentDay) else { return }
        
        // Block user's selections.
        let selections = blockItems.map(\.blockedContent)
        Self.blockSelections(selections: selections)
        
        // Sendability workaround since DeviceActivityName is not sendable.
        let stringActivityName = activity.rawValue
        
        if activityIdentifier.isFallback {
            let endTimeComponent = schedule.endTime
            Task {
                while TimeComponents(from: .now) != endTimeComponent {
                    try? await Task.sleep(nanoseconds: 5_000_000_000)
                }
                Self.unblockAll()
                DeviceActivityCenter()
                    .stopMonitoring(
                        [DeviceActivityName(stringActivityName)]
                    )
            }
            
        }
        
        
    }
    
    func handleBlockingEnd(for activity: DeviceActivityName) {
        Self.unblockAll()
    }
    
    private func fetchSchedule(id: UUID) -> Schedule? {
        // Create context from scratch because using mainContext in a
        // non-isolated to MainActor environment is not allowed.
        let context = ModelContext(container)
        
        // Fetch the schedule.
        let fetchDescriptor = FetchDescriptor<Schedule>(
            predicate: #Predicate<Schedule> { $0.id == id }
        )
        
        return try? context.fetch(fetchDescriptor).first
    }
    
    // MARK: - Helpers
    static private func blockSelections(selections: [FamilyActivitySelection]) {
        let store = ManagedSettingsStore()
        // Add all the items to discourage.
        var applicationsToDiscourage = Set<ApplicationToken>()
        var applicationCategoriesToDiscourage = Set<ActivityCategoryToken>()
        
        for selection in selections {
            applicationsToDiscourage.formUnion(selection.applicationTokens)
            applicationCategoriesToDiscourage.formUnion(selection.categoryTokens)
        }
        
        store.shield.applications = applicationsToDiscourage
        store.shield.applicationCategories = .specific(applicationCategoriesToDiscourage)
    }
    
    static private func unblockAll() {
        let store = ManagedSettingsStore()
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
}
