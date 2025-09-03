//
//  DeviceActivityCenterManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 12.08.2025.
//

import Foundation
import DeviceActivity

/// An actor protocol for managing device activity monitoring.
protocol DeviceActivityCenterManager: Actor {    
    /// The activities currently being monitored.
    var activities: [DeviceActivityName] { get }
    
    /// The activities currently being monitored, identified by UUIDs of BlockItem.
    var monitoredIdentifiers: Set<UUID> { get }
    
    /// Starts monitoring the specified device activity.
    /// - Parameters:
    ///   - name: The unique name for the device activity.
    ///   - schedule: The schedule during which to monitor.
    ///   - events: A dictionary of events and their thresholds.
    /// - Throws: `DeviceActivityCenter.MonitoringError` or other underlying errors.
    func startMonitoring(
        _ name: DeviceActivityName,
        during schedule: DeviceActivitySchedule,
        events: [DeviceActivityEvent.Name: DeviceActivityEvent]
    ) throws
    
    /// Starts monitoring the specified device activity without any event thresholds.
    /// - Parameters:
    ///   - name: The unique name for the device activity.
    ///   - schedule: The schedule during which to monitor.
    /// - Throws: `DeviceActivityCenter.MonitoringError` or other underlying errors.
    func startMonitoring(
        _ name: DeviceActivityName,
        during schedule: DeviceActivitySchedule
    ) throws
    
    /// Stops monitoring all device activities.
    func stopMonitoring()
    
    /// Stops monitoring the specified device activities.
    /// - Parameter names: The names of the activities to stop monitoring.
    func stopMonitoring(_ names: [DeviceActivityName])
    
    /// Fetches the events associated with a device activity.
    /// - Parameter name: The name of the device activity.
    func events(for name: DeviceActivityName) -> [DeviceActivityEvent.Name: DeviceActivityEvent]
    
    /// Fetches the schedule associated with a device activity.
    /// - Parameter name: The name of the device activity.
    func schedule(for name: DeviceActivityName) -> DeviceActivitySchedule?
}
