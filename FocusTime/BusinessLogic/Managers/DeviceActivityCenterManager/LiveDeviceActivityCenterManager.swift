//
//  LiveDeviceActivityCenterManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 12.08.2025.
//

import Foundation
import DeviceActivity
import os.log

actor LiveDeviceActivityCenterManager: DeviceActivityCenterManager {
    private let logger: Logger
    private let center = DeviceActivityCenter()
    
    init(
        logger: Logger = Logger(
            subsystem: SharedAppValues.appIdentifier,
            category: String(describing: LiveDeviceActivityCenterManager.self)
        )
    ) {
        self.logger = logger
        logger.info("LiveDeviceActivityCenterManager init")
    }
    
    deinit {
        logger.info("LiveDeviceActivityCenterManager deinit")
    }
    
    var activities: [DeviceActivityName] {
        let current = center.activities
        let names = current.map(\.rawValue).joined(separator: ", ")
        logger.debug("Accessed activities: \(names)")
        return current
    }
    
    var monitoredIdentifiers: Set<UUID> {
        let ids = Set(center.activities.compactMap { CodableActivityIdentifier(from: $0)?.blockItemID })
        let idList = ids.map(\.uuidString).joined(separator: ", ")
        logger.debug("Computed monitoredIdentifiers: \(idList)")
        return ids
    }
    
    func startMonitoring(
        _ name: DeviceActivityName,
        during schedule: DeviceActivitySchedule,
        events: [DeviceActivityEvent.Name : DeviceActivityEvent]
    ) throws {
        let eventNames = Array(events.keys).map(\.rawValue).joined(separator: ", ")
        logger.info("startMonitoring called with name=\(name.rawValue), schedule=\(String(describing: schedule)), events=[\(eventNames)]")
        do {
            try center.startMonitoring(name, during: schedule, events: events)
            logger.info("Successfully started monitoring with events for \(name.rawValue)")
        } catch {
            logger.error("startMonitoring(with events) failed for \(name.rawValue): \(String(describing: error))")
            throw error
        }
    }
    
    func startMonitoring(
        _ name: DeviceActivityName,
        during schedule: DeviceActivitySchedule
    ) throws {
        logger.info("startMonitoring called with name=\(name.rawValue), schedule=\(String(describing: schedule))")
        do {
            try center.startMonitoring(name, during: schedule)
            logger.info("Successfully started monitoring for \(name.rawValue)")
        } catch {
            logger.error("startMonitoring failed for \(name.rawValue): \(String(describing: error))")
            throw error
        }
    }
    
    func stopMonitoring() {
        logger.info("stopMonitoring called (all names)")
        center.stopMonitoring()
        logger.info("All monitoring stopped")
    }
    
    func stopMonitoring(_ names: [DeviceActivityName]) {
        let nameList = names.map(\.rawValue).joined(separator: ", ")
        logger.info("stopMonitoring called for names=[\(nameList)]")
        center.stopMonitoring(names)
        logger.info("Monitoring stopped for names=[\(nameList)]")
    }
    
    func events(for name: DeviceActivityName) -> [DeviceActivityEvent.Name : DeviceActivityEvent] {
        let result = center.events(for: name)
        let keys = Array(result.keys).map(\.rawValue).joined(separator: ", ")
        logger.debug("events(for: \(name.rawValue)) returned [\(keys)]")
        return result
    }
    
    func schedule(for name: DeviceActivityName) -> DeviceActivitySchedule? {
        let result = center.schedule(for: name)
        logger.debug("schedule(for: \(name.rawValue)) returned \(String(describing: result))")
        return result
    }
}
