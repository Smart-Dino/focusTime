//
//  LiveDeviceActivityRegistrar+Suspension.swift
//  FocusTime
//
//  Created by Maksym Horobets on 18.08.2025.
//

import SwiftData
import Foundation
import DeviceActivity

extension LiveDeviceActivityRegistrar {
    /// Suspend now and schedule a system-backed resume at `seconds` from now.
    /// This will persist resumeAt and register a DeviceActivity interval so the extension
    /// will be launched by the system and re-block when the time arrives.
    func suspendActivity(
        for blockItem: ProtectedBlockItem,
        forSeconds seconds: TimeInterval
    ) async throws {
        // 1. Immediate suspend.
        try await suspendActivity(for: blockItem)

        // 2. compute resume date.
        let now = await clock.now
        let resumeAt = now.addingTimeInterval(seconds)

        guard let persistentModelID = blockItem.persistentModelID else { return }

        // 3. persist resumeAt on the stored model so you can check it elsewise.
        var stored = try await blockItemPersistenceManager.fetch(by: persistentModelID)
        switch stored.type {
        case .scheduled(let startTime, let endTime, let isActive, _):
            stored.type = .scheduled(startTime: startTime, endTime: endTime, isActive: isActive, isPaused: true)
            try await blockItemPersistenceManager.editBlockItem(blockItem: stored)
        case .duration(let duration, _, _, let endDate):
            stored.type = .duration(duration, suspendedAt: now, suspendedUntil: resumeAt, endDate: endDate)
            try await blockItemPersistenceManager.editBlockItem(blockItem: stored)
        }

        // 4. register a DeviceActivity interval that starts at resumeAt's minute so the extension will fire.
        try await registerResumeMonitoring(blockItemID: blockItem.id, resumeAt: resumeAt)
    }
    
    /// When user manually resumes or unregisters, cancel the scheduled resume activity for that block item.
    func cancelScheduledResume(blockItemID: UUID) async throws {
        // Build the same DeviceActivityName.
        let activityIdentifier = CodableActivityIdentifier(blockItemID: blockItemID, actionType: .resumption)
        guard let jsonIdentifier = activityIdentifier.jsonString else { return }
        
        let activity = DeviceActivityName(jsonIdentifier)
        await centerManager.stopMonitoring([activity])

        // Also clear persisted resumeAt/suspendedAt.
        if var stored = (try? await blockItemPersistenceManager.fetch(by: blockItemID)) {
            switch stored.type {
            case .scheduled(let start, let end, let isActive, _):
                stored.type = .scheduled(startTime: start, endTime: end, isActive: isActive, isPaused: false)
                try await blockItemPersistenceManager.editBlockItem(blockItem: stored)
            case .duration(let duration, _, _, let endDate):
                stored.type = .duration(duration, suspendedAt: nil, suspendedUntil: nil, endDate: endDate)
                try await blockItemPersistenceManager.editBlockItem(blockItem: stored)
            }
        }
    }

    /// Register a DeviceActivity interval at the minute containing `resumeAt`.
    /// When the system wakes the DeviceActivity extension at that minute, your handler
    /// should detect the activity identifier and call `shieldManager.block(...)`.
    private func registerResumeMonitoring(blockItemID: UUID, resumeAt: Date) async throws {
        // Make an identifier with the UUID of the same block item but mark it as a resumption block.
        let identifier = CodableActivityIdentifier(blockItemID: blockItemID, actionType: .resumption)
        
        guard let jsonActivity = identifier.jsonString else { return } // Convert to system name.
        let activityName = DeviceActivityName(jsonActivity)
        
        // TimeComponents only accurate to the minute. Create start and end minute window.
        let startComponents = try TimeComponents(from: resumeAt).dateComponents
        // End 15 minutes later so our interval is valid for registration.
        let endDate = resumeAt.addingTimeInterval(TimeInterval(Self.fallbackIntervalSeconds))
        let endComponents = try TimeComponents(from: endDate).dateComponents
        
        // Build a schedule that has that single interval and does not repeat.
        let schedule = DeviceActivitySchedule(intervalStart: startComponents, intervalEnd: endComponents, repeats: false)
        
        // Start monitoring for that activity/schedule. This registration remains with the system
        // even after the process is suspended, so the extension will be invoked.
        try await centerManager.startMonitoring(activityName, during: schedule)
    }
}
