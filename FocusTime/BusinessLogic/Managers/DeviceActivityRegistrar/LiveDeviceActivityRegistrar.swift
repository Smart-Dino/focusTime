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

@MainActor
final class LiveDeviceActivityRegistrar: DeviceActivityRegistrar {
    private let center: DeviceActivityCenter
    private let shieldManager: ShieldManager
    private let modelContainer: ModelContainer
    
    var monitoredIdentifiers: Set<UUID> {
        Set(center.activities.compactMap {
            let uuidString = $0.rawValue.components(separatedBy: .whitespaces)[0]
            return UUID(uuidString: uuidString)
        })
    }
    
    init(
        center: DeviceActivityCenter = DeviceActivityCenter(),
        shieldManager: ShieldManager,
        modelContainer: ModelContainer
    ) {
        self.center = center
        self.shieldManager = shieldManager
        self.modelContainer = modelContainer
    }

    // Try to schedule event.
    // If schedule fails - use fallback method.
    func registerRegularActivity(during schedule: ProtectedSchedule) async throws {
        try await checkAuthorization()
        
        switch schedule.type {
        case .scheduled(let startTime, let endTime):
            do {
                try registerRegularActivity(for: schedule,
                                            startTime: startTime,
                                            endTime: endTime)
            } catch {
                // If this fails - error will get thrown from the function.
                try registerFallbackActivity(for: schedule,
                                             startTime: startTime,
                                             endTime: endTime)
            }
        case .oneTime(let duration):
            try registerDurationActivity(for: schedule, duration: duration)
        }
    }
    
    // Schedule an event like this: startTime - 15 minutes - endTime.
    // The startTime will be triggered with user's duration.
    // So if user sets duration of 1800 - 30 mins - then our startTime will be now + 30 mins.
    func registerDurationActivity(
        for schedule: ProtectedSchedule,
        duration: Int
    ) throws {
        guard let persistentModelID = schedule.persistentModelID else {
            throw DeviceActivityRegistrarError.noPersistentItem
        }
        
        // Block starts from now.
        Task.detached {
            let scheduleStore = ScheduleStore(modelContainer: self.modelContainer)
            let protectedBlockItems = try await scheduleStore.fetchRelatedObjects(id: persistentModelID)
            
            _ = await MainActor.run {
                Task {
                    try? await self.shieldManager.block(specific: protectedBlockItems.map(\.blockedContent))
                }
            }
        }
        
        let now = Calendar.current.dateComponents([.hour, .minute], from: .now)
        
        // Now schedule activity to end blockage.
        guard let intervalStart = now.adding(seconds: duration),
              let intervalEnd = intervalStart.adding(seconds: 15 * 60) else { return }
        
        let deviceActivitySchedule = DeviceActivitySchedule(intervalStart: intervalStart,
                                                            intervalEnd: intervalEnd,
                                                            repeats: true)
        
        // Let the DeviceActivityMonitorExtension know that we need a regular scenario.
        guard let activityIdentifier = CodableActivityIdentifier(scheduleID: schedule.id,
                                                                 isFallback: false).jsonString
        else { throw DeviceActivityRegistrarError.couldNotGenerateIdentifier }
        
        let activityName = DeviceActivityName(activityIdentifier)
        
        try center.startMonitoring(activityName, during: deviceActivitySchedule)
    }
    
    private func registerRegularActivity(
        for schedule: ProtectedSchedule,
        startTime: TimeComponents,
        endTime: TimeComponents
    ) throws {
        guard schedule.persistentModelID != nil else { throw DeviceActivityRegistrarError.noPersistentItem }
        
        let intervalStart = startTime.dateComponents
        let intervalEnd = endTime.dateComponents
        let deviceActivitySchedule = DeviceActivitySchedule(intervalStart: intervalStart,
                                                            intervalEnd: intervalEnd,
                                                            repeats: true)
        
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
    ) throws {
        guard schedule.persistentModelID != nil else { throw DeviceActivityRegistrarError.noPersistentItem }
        
        let intervalStart = startTime.dateComponents
        // Shift interval end to satisfy DeviceActivityCenter - workaround.
        guard let intervalEnd = endTime.dateComponents.adding(seconds: 15 * 60) else {
            throw DeviceActivityRegistrarError.couldNotSetTime
        }
        let deviceActivitySchedule = DeviceActivitySchedule(intervalStart: intervalStart,
                                                            intervalEnd: intervalEnd,
                                                            repeats: true)
        
        // Let the DeviceActivityMonitorExtension know that we need a fallback scenario.
        guard let activityIdentifier = CodableActivityIdentifier(scheduleID: schedule.id,
                                                                 isFallback: true).jsonString
        else { throw DeviceActivityRegistrarError.couldNotGenerateIdentifier }
        
        let activityName = DeviceActivityName(activityIdentifier)
        
        try center.startMonitoring(activityName, during: deviceActivitySchedule)
    }
    
    func unregisterActivity(during schedule: ProtectedSchedule) async throws {
        guard let activity = center.activities.first(where: { $0.rawValue.contains(schedule.id.uuidString) }) else {
            throw DeviceActivityRegistrarError.activityNotFound
        }
        center.stopMonitoring([activity])
    }
    
    func unregisterAll() {
        center.stopMonitoring()
    }
    
    func checkAuthorization() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }
}

