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
    private let center = DeviceActivityCenter()
    private let store = ManagedSettingsStore()
//    private let container = try! ModelContainer(
//        for: Schema([Schedule.self, BlockItem.self]),
//        configurations: ModelConfiguration(
//            allowsSave: false,
//            groupContainer: .identifier(AppValues.appGroupIdentifier)
//        )
//    )
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        store.shield.applicationCategories = .all()
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
