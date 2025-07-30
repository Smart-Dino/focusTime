//
//  DeviceActivityMonitorExtension.swift
//  FocusTimeActivityMonitor
//
//  Created by Maksym Horobets on 24.06.2025.
//

import os.log
import SwiftData
import Foundation
import DeviceActivity


// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
final class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    static private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? #file,
        category: String(describing: DeviceActivityMonitorExtension.self)
    )
    let handler = DeviceActivityHandler(
        container: DeviceActivityMonitorExtension.container,
        shieldManager: LiveShieldManager(isRunningInExtension: true)
    )
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        let handler = self.handler
        let nameString = activity.rawValue
        Task {
            await handler.handleBlockingStart(for: DeviceActivityName(nameString))
        }
    }
    
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        let handler = self.handler
        let nameString = activity.rawValue
        Task {
            await handler.handleBlockingEnd(for: DeviceActivityName(nameString))
        }
    }
    
    static var container: ModelContainer {
        let schema = Schema([BlockItem.self])
        let configurations = [
            ModelConfiguration(
                allowsSave: false,
                groupContainer: .identifier(AppValues.appGroupIdentifier)
            )
        ]
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: configurations
            )
        } catch {
            Self.logger.error("Failed to initialize ModelContainer in extension with error: \(error)")
            fatalError("ModelContainer initialization failed, shutting down.")
        }
    }
}
