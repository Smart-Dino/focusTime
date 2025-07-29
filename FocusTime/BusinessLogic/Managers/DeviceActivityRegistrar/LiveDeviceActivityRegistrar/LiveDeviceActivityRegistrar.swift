//
//  LiveDeviceActivityRegistrar.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//

import Foundation
import SwiftData
import DeviceActivity
import FamilyControls

actor LiveDeviceActivityRegistrar: DeviceActivityRegistrar {
    private static let fallbackIntervalSeconds = 15 * 60
    private let clock: Clock
    let center: DeviceActivityCenter
    private let shieldManager: ShieldManager
    private let scheduleStore: ScheduleStore
    
    var monitoredIdentifiers: Set<UUID> {
        Set(center.activities.compactMap {
            guard let identifier = CodableActivityIdentifier(from: $0) else { return nil }
            return identifier.scheduleID
        })
    }
    
    init(
        center: DeviceActivityCenter = DeviceActivityCenter(),
        clock: Clock = SystemClock(),
        scheduleStore: ScheduleStore,
        shieldManager: ShieldManager
    ) {
        self.center = center
        self.clock = clock
        self.scheduleStore = scheduleStore
        self.shieldManager = shieldManager
    }
    
    // Try to schedule event.
    // If schedule fails - use fallback method.
    func registerActivity(during schedule: ProtectedSchedule) async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        
        switch schedule.type {
        case .scheduled(let startTime, let endTime):
            do {
                try await registerRegularActivity(for: schedule,
                                                  startTime: startTime,
                                                  endTime: endTime)
            } catch {
                switch error {
                case DeviceActivityCenter.MonitoringError.intervalTooShort:
                    try await registerFallbackActivity(for: schedule,
                                                       startTime: startTime,
                                                       endTime: endTime)
                default:
                    throw error
                }
            }
        case .oneTime(let duration, _, _, _):
            try await registerDurationActivity(for: schedule, duration: duration.rawValue)
        }
    }
    
    // Schedule an event like this: startTime - 15 minutes - endTime.
    // The startTime will be triggered with user's duration.
    // So if user sets duration of 1800 - 30 mins - then our startTime will be now + 30 mins.
    func registerDurationActivity(
        for schedule: ProtectedSchedule,
        duration: Int
    ) async throws {
        guard let persistentModelID = schedule.persistentModelID else {
            throw DeviceActivityRegistrarError.noPersistentItem
        }
        
        // Copy values to avoid capturing self in the Tasks.
        let shieldManager = self.shieldManager
        
        // Block starts from now.
        let protectedBlockItems = try await scheduleStore.fetchRelatedObjects(id: persistentModelID)
        try await shieldManager.block(specific: protectedBlockItems.map(\.blockedContent))
        
        let now = Calendar.current.dateComponents([.hour, .minute], from: await clock.now)
        
        // Now schedule activity to end blockage.
        // The DeviceActivitySchedule interval requires the schedule to be 15 or more minutes long
        // so the intervalEnd is offset by that 15 minutes.
        let intervalStart = now.adding(seconds: duration)
        let intervalEnd = intervalStart.adding(seconds: Self.fallbackIntervalSeconds)
        
        let deviceActivitySchedule = DeviceActivitySchedule(intervalStart: intervalStart,
                                                            intervalEnd: intervalEnd,
                                                            repeats: true)
        
        // Let the DeviceActivityMonitorExtension know that we need a regular scenario.
        guard let activityIdentifier = CodableActivityIdentifier(scheduleID: schedule.id,
                                                                 isFallback: false).jsonString
        else { throw DeviceActivityRegistrarError.couldNotGenerateIdentifier }
        
        let activityName = DeviceActivityName(activityIdentifier)
        
        try center.startMonitoring(activityName, during: deviceActivitySchedule)
        
        // Log when the activity was started for proper suspension handling.
        let startTime = await clock.now
        try await scheduleStore.updateFields(id: persistentModelID) { schedule in
            switch schedule.type {
            case .oneTime(let originalDuration, _, _, _):
                schedule.type = .oneTime(
                    originalDuration, // Make sure this is the original value!
                    startedAt: startTime,
                    suspendedAt: nil,
                    timeLeft: DurationComponents(duration: duration) // And make sure this is the actual intended duration!
                )
            default:
                break
            }
        }
    }
    
    private func registerRegularActivity(
        for schedule: ProtectedSchedule,
        startTime: TimeComponents,
        endTime: TimeComponents
    ) async throws {
        guard schedule.persistentModelID != nil else {
            throw DeviceActivityRegistrarError.noPersistentItem
        }
        
        let intervalStart = startTime.dateComponents
        let intervalEnd = endTime.dateComponents
        let deviceActivitySchedule = DeviceActivitySchedule(intervalStart: intervalStart,
                                                            intervalEnd: intervalEnd,
                                                            repeats: true)
        
        let overlapSchedules = try await overlapsWithAlreadyRegisteredSchedules(
            deviceActivitySchedule,
            days: schedule.days
        )
        guard overlapSchedules.isEmpty else {
            throw DeviceActivityRegistrarError.scheduleOverlap(with: overlapSchedules)
        }
        
        // Let the DeviceActivityMonitorExtension know that we need a regular scenario.
        guard let activityIdentifier = CodableActivityIdentifier(scheduleID: schedule.id,
                                                                 isFallback: false).jsonString
        else { throw DeviceActivityRegistrarError.couldNotGenerateIdentifier }
        
        let activityName = DeviceActivityName(activityIdentifier)
        
        try center.startMonitoring(activityName, during: deviceActivitySchedule)
    }
    
    private func registerFallbackActivity(
        for schedule: ProtectedSchedule,
        startTime: TimeComponents,
        endTime: TimeComponents
    ) async throws {
        guard schedule.persistentModelID != nil else { throw DeviceActivityRegistrarError.noPersistentItem }
        
        let intervalStart = startTime.dateComponents
        // Shift interval end to satisfy DeviceActivityCenter - workaround.
        let intervalEnd = endTime.dateComponents.adding(seconds: Self.fallbackIntervalSeconds)

        let deviceActivitySchedule = DeviceActivitySchedule(intervalStart: intervalStart,
                                                            intervalEnd: intervalEnd,
                                                            repeats: true)
        
        let overlapSchedules = try await overlapsWithAlreadyRegisteredSchedules(
            deviceActivitySchedule,
            days: schedule.days
        )
        guard overlapSchedules.isEmpty else {
            throw DeviceActivityRegistrarError.scheduleOverlap(with: overlapSchedules)
        }
        
        // Let the DeviceActivityMonitorExtension know that we need a fallback scenario.
        guard let activityIdentifier = CodableActivityIdentifier(scheduleID: schedule.id,
                                                                 isFallback: true).jsonString
        else { throw DeviceActivityRegistrarError.couldNotGenerateIdentifier }
        
        let activityName = DeviceActivityName(activityIdentifier)
        
        try center.startMonitoring(activityName, during: deviceActivitySchedule)
    }
    
    private func overlapsWithAlreadyRegisteredSchedules(
        _ newSchedule: DeviceActivitySchedule,
        days: Set<Weekday>,
        on calendar: Calendar = .current
    ) async throws -> [ProtectedSchedule] {
        var overlappingSchedules: [ProtectedSchedule] = []
        
        let activities = center.activities
        
        for activity in activities {
            guard
                let existingSchedule = center.schedule(for: activity),
                let start1 = calendar.date(from: newSchedule.intervalStart),
                let end1 = calendar.date(from: newSchedule.intervalEnd),
                let start2 = calendar.date(from: existingSchedule.intervalStart),
                let end2 = calendar.date(from: existingSchedule.intervalEnd)
            else {
                // Failed to resolve one or more DateComponents.
                throw DeviceActivityRegistrarError.couldNotCheckOverlap
            }
            if start1 < end2 && start2 < end1 {
                // Overlap detected.
                // Find schedule related to this activity:
                
                // 1. Decode activity name.
                guard let decoded = CodableActivityIdentifier(from: activity) else {
                    throw DeviceActivityRegistrarError.couldNotCheckOverlap
                }
                // 2. Get the schedule ID from it.
                let scheduleID = decoded.scheduleID
                // 3. Fetch schedule.
                let overlappingSchedule = try await scheduleStore.fetch(
                    descriptor: .init(predicate: #Predicate { $0.id == scheduleID })
                ).first
                // 4. Make sure days overlap too and add schedule to return list.
                if let overlappingSchedule, overlappingSchedule.days.isDisjoint(with: days) == false {
                    overlappingSchedules.append(overlappingSchedule)
                }
            }
        }
        return overlappingSchedules
    }
    
    func unregisterActivity(during schedule: ProtectedSchedule) async throws {
        let activity = try getActivityForSchedule(schedule)
        center.stopMonitoring([activity])
    }
    
    func suspendActivity(for schedule: ProtectedSchedule) async throws {
        let suspensionDate = await clock.now
        guard let persistentModelID = schedule.persistentModelID else {
            throw DeviceActivityRegistrarError.activityNotFound
        }
        let activity = try getActivityForSchedule(schedule)
        
        // Make sure we have the latest schedule.
        let schedule = try await scheduleStore.fetch(id: persistentModelID)
        
        switch schedule.type {
        case .scheduled:
            try await shieldManager.unblock()
        case .oneTime(let duration, let startedAt, _, let timeLeft):
            guard let startedAt else {
                throw DeviceActivityRegistrarError.couldNotExtractDatePoints
            }
            
            // Calculate how much time was left before unblock.
            let elapsedTime = suspensionDate.timeIntervalSince(startedAt)
            let updatedTimeLeft = max(0, timeLeft.rawValue - Int(elapsedTime))
            
            // Set suspension point and timeLeft.
            try await scheduleStore.updateFields(id: persistentModelID) { editedSchedule in
                editedSchedule.type = .oneTime(
                    duration,
                    startedAt: startedAt,
                    suspendedAt: suspensionDate,
                    timeLeft: DurationComponents(duration: updatedTimeLeft)
                )
            }
            
            // Unblock apps.
            try await shieldManager.unblock()
            
            // Stop monitoring activity.
            center.stopMonitoring([activity])
        }
    }
    
    // The activity isn't always 100% accurate since DeviceActivitySchedule does not account for seconds.
    func resumeActivity(for schedule: ProtectedSchedule) async throws {
        let resumptionDate = await clock.now
        guard let persistentModelID = schedule.persistentModelID else {
            throw DeviceActivityRegistrarError.activityNotFound
        }
        
        // Make sure we have the latest schedule.
        let schedule = try await scheduleStore.fetch(id: persistentModelID)
        
        switch schedule.type {
        case .scheduled:
            let protectedBlockItems = try await scheduleStore.fetchRelatedObjects(id: persistentModelID)
            try await shieldManager.block(specific: protectedBlockItems.map(\.blockedContent))
        case .oneTime(let duration, _, _, let timeLeft):
            
            // Set that the schedule is no longer suspended and log the new time left.
            try await scheduleStore.updateFields(id: persistentModelID) { editedSchedule in
                editedSchedule.type = .oneTime(
                    duration,
                    startedAt: resumptionDate,
                    suspendedAt: nil,
                    timeLeft: timeLeft
                )
            }
            try await registerDurationActivity(for: schedule, duration: timeLeft.rawValue)
        }
    }
    
    func isActivityRegistered(for schedule: ProtectedSchedule) throws -> Bool {
        guard schedule.persistentModelID != nil else {
            throw DeviceActivityRegistrarError.activityNotFound
        }
        
        if (try? getActivityForSchedule(schedule)) != nil {
            return true
        } else {
            return false
        }
    }
    
    func unregisterAll() {
        center.stopMonitoring()
    }
}

