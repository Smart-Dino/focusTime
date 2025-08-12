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
        center.activities
    }
    
    var monitoredIdentifiers: Set<UUID> {
        Set(center.activities.compactMap {
            guard let identifier = CodableActivityIdentifier(from: $0) else { return nil }
            return identifier.blockItemID
        })
    }
    
    func startMonitoring(
        _ name: DeviceActivityName,
        during schedule: DeviceActivitySchedule,
        events: [DeviceActivityEvent.Name : DeviceActivityEvent]
    ) throws {
        try center.startMonitoring(name, during: schedule, events: events)
    }
    
    func startMonitoring(
        _ name: DeviceActivityName,
        during schedule: DeviceActivitySchedule
    ) throws {
        try center.startMonitoring(name, during: schedule)
    }
    
    func stopMonitoring() {
        center.stopMonitoring()
    }
    
    func stopMonitoring(_ names: [DeviceActivityName]) {
        center.stopMonitoring(names)
    }
    
    func events(for name: DeviceActivityName) -> [DeviceActivityEvent.Name : DeviceActivityEvent] {
        center.events(for: name)
    }
    
    func schedule(for name: DeviceActivityName) -> DeviceActivitySchedule? {
        center.schedule(for: name)
    }
}
