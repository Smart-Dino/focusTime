//
//  DeviceActivityMonitorExtension.swift
//  FocusTimeActivityMonitor
//
//  Created by Maksym Horobets on 24.06.2025.
//

import DeviceActivity
import ManagedSettings
import Foundation
import SwiftData
import FamilyControls

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
final class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let store = ManagedSettingsStore()
    private let container = try! ModelContainer(
        for: Schedule.self,
        configurations: ModelConfiguration(allowsSave: false, groupContainer: .identifier(appGroupIdentifier))
    )
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
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
        
#warning("Determine the day of the week and decide to kick in with blocking or not.")
        if blockingPhase == "start" {
            // Fetch the schedule.
            let fetchDescriptor = FetchDescriptor<Schedule>(
                predicate: #Predicate<Schedule> { $0.id == identifier }
            )
            let schedule = try? context.fetch(fetchDescriptor).first
            
            // Make sure we have our schedule.
            guard let schedule, let blockItems = schedule.blockItems else { return }
            
            // Add all the items to discourage.
            var applicationsToDiscourage = Set<ApplicationToken>()
            var applicationCategoriesToDiscourage = Set<ActivityCategoryToken>()
            
            for blockItem in blockItems {
                let blockedContent = blockItem.blockedContent
                applicationsToDiscourage.formUnion(blockedContent.applicationTokens)
                applicationCategoriesToDiscourage.formUnion(blockedContent.categoryTokens)
            }
            
            // Block selected applications.
            if applicationsToDiscourage.isEmpty {
                store.shield.applications = nil
            } else {
                store.shield.applications = applicationsToDiscourage
            }
            
            // Block selected categories.
            if applicationCategoriesToDiscourage.isEmpty {
                store.shield.applicationCategories = nil
            } else {
                store.shield.applicationCategories = .specific(applicationCategoriesToDiscourage)
            }
            
        } else {
            store.shield.applications = nil
            store.shield.applicationCategories = nil
        }
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}
