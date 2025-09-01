//
//  LiveDeviceActivityCenterManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 12.08.2025.
//

import Foundation
import DeviceActivity

actor LiveDeviceActivityCenterManager: DeviceActivityCenterManager {
    let center = DeviceActivityCenter()
    
    var activities: [DeviceActivityName] {
        let current = center.activities
        print("[LiveDeviceActivityCenterManager] Accessed activities: \(current)")
        return current
    }
    
    var monitoredIdentifiers: Set<UUID> {
        let identifiers = Set<UUID>(center.activities.compactMap {
            guard let identifier = CodableActivityIdentifier(from: $0) else { return nil }
            return identifier.blockItemID
        })
        print("[LiveDeviceActivityCenterManager] Computed monitoredIdentifiers: \(identifiers)")
        return identifiers
    }
    
    func startMonitoring(
        _ name: DeviceActivityName,
        during schedule: DeviceActivitySchedule,
        events: [DeviceActivityEvent.Name : DeviceActivityEvent]
    ) throws {
        print("[LiveDeviceActivityCenterManager] startMonitoring called with name=\(name), schedule=\(schedule), events=\(events.keys)")
        try center.startMonitoring(name, during: schedule, events: events)
        print("[LiveDeviceActivityCenterManager] Successfully started monitoring with events for \(name)")
    }
    
    func startMonitoring(
        _ name: DeviceActivityName,
        during schedule: DeviceActivitySchedule
    ) throws {
        print("[LiveDeviceActivityCenterManager] startMonitoring called with name=\(name), schedule=\(schedule)")
        try center.startMonitoring(name, during: schedule)
        print("[LiveDeviceActivityCenterManager] Successfully started monitoring for \(name)")
    }
    
    func stopMonitoring() {
        print("[LiveDeviceActivityCenterManager] stopMonitoring called (all names)")
        center.stopMonitoring()
        print("[LiveDeviceActivityCenterManager] All monitoring stopped")
    }
    
    func stopMonitoring(_ names: [DeviceActivityName]) {
        print("[LiveDeviceActivityCenterManager] stopMonitoring called for names=\(names)")
        center.stopMonitoring(names)
        print("[LiveDeviceActivityCenterManager] Monitoring stopped for \(names)")
    }
    
    func events(for name: DeviceActivityName) -> [DeviceActivityEvent.Name : DeviceActivityEvent] {
        let result = center.events(for: name)
        print("[LiveDeviceActivityCenterManager] events(for: \(name)) returned \(result.keys)")
        return result
    }
    
    func schedule(for name: DeviceActivityName) -> DeviceActivitySchedule? {
        let result = center.schedule(for: name)
        print("[LiveDeviceActivityCenterManager] schedule(for: \(name)) returned \(String(describing: result))")
        return result
    }
}
