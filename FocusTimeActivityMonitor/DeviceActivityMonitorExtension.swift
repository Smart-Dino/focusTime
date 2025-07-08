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
//    private let center = DeviceActivityCenter()
//    private let store = ManagedSettingsStore()
//    private let container = try! ModelContainer(
//        for: Schema([Schedule.self, BlockItem.self]),
//        configurations: ModelConfiguration(
//            allowsSave: false,
//            groupContainer: .identifier(AppValues.appGroupIdentifier)
//        )
//    )
    
    var countdownTask: Task<Void, Never>? = nil
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
//        let store = ManagedSettingsStore()
        let defaults = UserDefaults(suiteName: AppValues.appGroupIdentifier)!
        let key = "LOG_STRINGS"
        countdownTask = Task {
            var count = 0
            let store = ManagedSettingsStore()
            store.shield.applicationCategories = .all()
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                count += 1
                var logs = defaults.stringArray(forKey: key) ?? []
                let hours = count / 3600
                let minutes = (count % 3600) / 60
                let seconds = count % 60
                let formatted = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                
                if minutes == 12 {
                    logs.append("Run is on minute 12, unblocking...")
                    store.shield.applicationCategories = nil
                    logs.append("Unblocked, breaking out of the loop.")
                    defaults.set(logs, forKey: key)
                    break
                }
                logs.append("Run, time \(formatted) - \(Date().formatted(date: .omitted, time: .complete)).")
                defaults.set(logs, forKey: key)
                
                
            }
        }
        
//        let activityHandler = DeviceActivityHandler(store: store,
//                                                    container: container)
//        
//        activityHandler.handleIntervalStart(for: activity)
//        center.stopMonitoring([activity])
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
    }
}
