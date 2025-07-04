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
    private let store: ManagedSettingsStore
    private let container: ModelContainer
    
    init(
        store: ManagedSettingsStore,
        container: ModelContainer
    ) {
        self.store = store
        self.container = container
    }
    
    func handleIntervalStart(for activity: DeviceActivityName) {
        // Create context from scratch because using mainContext in a
        // non-isolated to MainActor environment is not allowed.
        let context = ModelContext(container)
        
        // Separate id and the start-end identifier.
        let idComponents = activity.rawValue.components(separatedBy: .whitespaces)
        
        // Convert the string-based schedule identifier back into a UUID because SwiftData's #Predicate closures
        // are compiled down to NSPredicate under the hood. NSPredicate cannot understand or evaluate Swift-specific
        // expressions like `id.uuidString`.
        // As a result, using `id.uuidString == identifier` silently fails and returns no matches.
        guard let identifier = UUID(uuidString: idComponents[0]) else { return }
        
        // Determine if it is a start or the end of the schedule.
        let blockingPhase = idComponents[1]
        
        if blockingPhase == "start" {
            // Fetch the schedule.
            let fetchDescriptor = FetchDescriptor<Schedule>(
                predicate: #Predicate<Schedule> { $0.id == identifier }
            )
            let schedule = try? context.fetch(fetchDescriptor).first
            
            // Make sure we have our schedule.
            guard let schedule, let blockItems = schedule.blockItems else { return }
            
            // Make sure the current day is the block day.
            guard schedule.days.contains(Weekday.currentDay) else { return }
            
            let selections = blockItems.map(\.blockedContent)
            blockSelections(selections: selections)
            
        } else {
            unblockAll()
        }
        
        
    }
    
    // MARK: - Helpers
    private func blockSelections(selections: [FamilyActivitySelection]) {
        // Add all the items to discourage.
        var applicationsToDiscourage = Set<ApplicationToken>()
        var applicationCategoriesToDiscourage = Set<ActivityCategoryToken>()
        
        for selection in selections {
            applicationsToDiscourage.formUnion(selection.applicationTokens)
            applicationCategoriesToDiscourage.formUnion(selection.categoryTokens)
        }
        
        // Block selected applications.
//        if applicationsToDiscourage.isEmpty {
//            store.shield.applications = nil
//        } else {
            store.shield.applications = applicationsToDiscourage
//        }
        
        // Block selected categories.
//        if applicationCategoriesToDiscourage.isEmpty {
//            store.shield.applicationCategories = nil
//        } else {
            store.shield.applicationCategories = .specific(applicationCategoriesToDiscourage)
//        }
    }
    
    private func unblockAll() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
}
