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
        for: BlockItem.self,
        configurations: ModelConfiguration(groupContainer: .identifier(appGroupIdentifier))
    )
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
//        let context = ModelContext(container)
        
        // Separate id and the start-end identifier.
        let idComponents = activity.rawValue.components(separatedBy: .whitespaces)
        // Schedule id.
        let identifier = idComponents[0]
        // Determine if it is a start or the end of the schedule.
        let blockingPhase = idComponents[1]
        
        #warning("Determine the day of the week and decide to kick in with blocking or not.")
        store.shield.applicationCategories = .all()
//        Task { @MainActor in
//            if blockingPhase == "start" {
//                // Fetch the schedule.
//                let fetchDescriptor = FetchDescriptor<Schedule>(
//                    predicate: #Predicate { $0.id.uuidString == identifier }
//                )
//                let schedule = try! scheduleStore.fetch(descriptor: fetchDescriptor).first
//                
//                // Make sure we have our schedule.
//                guard let schedule else { return }
//                
//                // Add all the items to discourage.
//                var applicationsToDiscourage = Set<ApplicationToken>()
//                var applicationCategoriesToDiscourage = Set<ActivityCategoryToken>()
//                
//                for blockItem in schedule.blockItems {
//                    let blockedContent = blockItem.blockedContent
//                    applicationsToDiscourage.formUnion(blockedContent.applicationTokens)
//                    applicationCategoriesToDiscourage.formUnion(blockedContent.categoryTokens)
//                }
//                
//                // Block selected applications.
//                if applicationsToDiscourage.isEmpty {
//                    store.shield.applications = nil
//                } else {
//                    store.shield.applications = applicationsToDiscourage
//                }
//                
//                // Block selected categories.
//                if applicationCategoriesToDiscourage.isEmpty {
//                    store.shield.applicationCategories = nil
//                } else {
//                    store.shield.applicationCategories = .specific(applicationCategoriesToDiscourage)
//                }
//                
//            } else {
//                store.shield.applications = nil
//                store.shield.applicationCategories = nil
//            }
//        }
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
