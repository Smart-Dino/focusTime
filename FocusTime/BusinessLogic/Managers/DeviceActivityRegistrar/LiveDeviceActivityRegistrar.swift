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
    
    // The reason why we schedule two schedules instead of one
    // is because if the user wants an interval to be less than 15 minutes
    // - the system will not allow us to do so and throw an error.
    // We can solve this by having two separate schedules that are both 15+
    // mins in length but have less than 15 minutes in-between them!
    func registerActivity(during schedule: ProtectedSchedule) async throws {
        guard schedule.persistentModelID != nil else { throw ShieldManagerError.noPersistentItem }
        try await checkAuthorization()
        
        // Start of interval + 15 mins.
        let intervalStart = schedule.startTime.dateComponents
        guard let startAddingFifteen = intervalStart.adding(minutes: 15) else {
            throw ShieldManagerError.couldNotSetTime
        }
        
        // End of interval + 15 mins.
        let intervalEnd = schedule.endTime.dateComponents
        guard let endAddingFifteen = intervalEnd.adding(minutes: 15) else {
            throw ShieldManagerError.couldNotSetTime
        }
        
        // Generate ids for querying DB.
        let deviceActivityStartName = DeviceActivityName(schedule.id.uuidString + " start")
        let deviceActivityEndName = DeviceActivityName(schedule.id.uuidString + " end")
        
        // Schedule both events.
        let deviceActivityScheduleStart = DeviceActivitySchedule(intervalStart: intervalStart,
                                                            intervalEnd: startAddingFifteen,
                                                            repeats: true)
        
        let deviceActivityScheduleEnd = DeviceActivitySchedule(intervalStart: intervalEnd,
                                                            intervalEnd: endAddingFifteen,
                                                            repeats: true)
        
        // Start monitoring events.
        try center.startMonitoring(deviceActivityStartName, during: deviceActivityScheduleStart)
//        try center.startMonitoring(deviceActivityEndName, during: deviceActivityScheduleEnd)
    }
    
    func unregisterAll() {
        center.stopMonitoring()
    }
    
    func checkAuthorization() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }
}
