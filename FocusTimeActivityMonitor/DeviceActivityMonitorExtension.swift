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
    let handler = DeviceActivityHandler(container: container)
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        handler.handleBlockingStart(for: activity)
    }
    
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        handler.handleBlockingEnd(for: activity)
    }
    
    static var container: ModelContainer {
        let schema = Schema([Schedule.self, BlockItem.self])
        let configurations = [
            ModelConfiguration(
                allowsSave: false,
                groupContainer: .identifier(AppValues.appGroupIdentifier)
            )
        ]
        
        // Force try because there is no reason to handle errors in an extension.
        // TODO: Perhaps we could have a logger here.
        return try! ModelContainer(
            for: schema,
            configurations: configurations
        )
    }
}
