//
//  LiveDeviceActivityRegistrar.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//

import Foundation
import DeviceActivity
import FamilyControls

@MainActor
final class LiveDeviceActivityRegistrar: DeviceActivityRegistrar {
    
    private let center: DeviceActivityCenter
    
    var monitoredIdentifiers: Set<UUID> {
        Set(center.activities.compactMap {
            let uuidString = $0.rawValue.components(separatedBy: .whitespaces)[0]
            return UUID(uuidString: uuidString)
        })
    }
    
    init(center: DeviceActivityCenter = DeviceActivityCenter()) {
        self.center = center
    }

    func registerActivity(during schedule: ProtectedSchedule) async throws {
        // Try to schedule event.
        // If schedule fails - use fallback method.
        try await checkAuthorization()
        
        do {
            try registerRegularActivity(for: schedule)
        } catch {
            // If this fails - error will get thrown from the function.
            try registerFallbackActivity(for: schedule)
        }
    }
    
    private func registerRegularActivity(for schedule: ProtectedSchedule) throws {
        guard schedule.persistentModelID != nil else { throw ShieldManagerError.noPersistentItem }
        
        let intervalStart = schedule.startTime.dateComponents
        let intervalEnd = schedule.endTime.dateComponents
        let deviceActivitySchedule = DeviceActivitySchedule(intervalStart: intervalStart,
                                                            intervalEnd: intervalEnd,
                                                            repeats: true)
        
        // Let the DeviceActivityMonitorExtension know that we need a regular scenario.
        guard let activityIdentifier = CodableActivityIdentifier(scheduleID: schedule.id,
                                                                 isFallback: false).jsonString
        else { throw ShieldManagerError.couldNotGenerateIdentifier }
        
        let activityName = DeviceActivityName(activityIdentifier)
        
        try center.startMonitoring(activityName, during: deviceActivitySchedule)
        
    }
    
    private func registerFallbackActivity(for schedule: ProtectedSchedule) throws {
        guard schedule.persistentModelID != nil else { throw ShieldManagerError.noPersistentItem }
        
        let intervalStart = schedule.startTime.dateComponents
        // Shift interval end to satisfy DeviceActivityCenter - workaround.
        guard let intervalEnd = schedule.endTime.dateComponents.adding(minutes: 15) else {
            throw ShieldManagerError.couldNotSetTime
        }
        let deviceActivitySchedule = DeviceActivitySchedule(intervalStart: intervalStart,
                                                            intervalEnd: intervalEnd,
                                                            repeats: true)
        
        // Let the DeviceActivityMonitorExtension know that we need a fallback scenario.
        guard let activityIdentifier = CodableActivityIdentifier(scheduleID: schedule.id,
                                                                 isFallback: true).jsonString
        else { throw ShieldManagerError.couldNotGenerateIdentifier }
        
        let activityName = DeviceActivityName(activityIdentifier)
        
        try center.startMonitoring(activityName, during: deviceActivitySchedule)
    }
    
    func unregisterAll() {
        center.stopMonitoring()
    }
    
    func checkAuthorization() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }
}
