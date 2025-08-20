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
    
    func suspendActivity(
        for blockItem: ProtectedBlockItem,
        forSeconds seconds: Int
    ) async throws {
        guard let persistentModelID = blockItem.persistentModelID else {
            throw DeviceActivityRegistrarError.activityNotFound
        }
        guard let secondsLeft = blockItem.type.secondsToIntervalEndIfShouldBeRunning(),
              secondsLeft > seconds else {
            throw DeviceActivityRegistrarError.cannotSuspend
        }
        
        let suspensionDate = await clock.now
        let suspendedUntil = suspensionDate.addingTimeInterval(TimeInterval(seconds))
    
        let activity = try await getActivityForSchedule(blockItem)
        var stored = try await blockItemPersistenceManager.fetch(by: persistentModelID)

        switch stored.type {
        case .scheduled(let startTime, let endTime, let isActive, _, _):
            stored.type = .scheduled(
                startTime: startTime,
                endTime: endTime,
                isActive: isActive,
                isPaused: true,
                suspendedUntil: suspendedUntil
            )
            
            try await blockItemPersistenceManager.editBlockItem(blockItem: stored)
            try await shieldManager.unblock()
        case .duration(let duration, _, _, let endDate):
            guard let endDate else {
                throw DeviceActivityRegistrarError.couldNotExtractDatePoints
            }
            // Store suspension moment and keep endDate unchanged.
            stored.type = .duration(
                duration,
                suspendedAt: suspensionDate,
                suspendedUntil: suspendedUntil,
                endDate: endDate.addingTimeInterval(TimeInterval(seconds))
            )
            
            try await blockItemPersistenceManager.editBlockItem(blockItem: stored)
            try await shieldManager.unblock()
            
            await centerManager.stopMonitoring([activity])
        }
        
        try await registerResumeMonitoring(blockItemID: blockItem.id, resumeAt: suspendedUntil)
    }
    
    /// When user manually resumes or unregisters, cancel the scheduled resume activity for that block item.
    func cancelScheduledResume(for blockItem: ProtectedBlockItem) async throws {
        guard blockItem.persistentModelID != nil else { throw DeviceActivityRegistrarError.noPersistentItem }
        
        // Build the same DeviceActivityName.
        let activityIdentifier = CodableActivityIdentifier(blockItemID: blockItem.id, blockType: .resumption)
        guard let jsonIdentifier = activityIdentifier.jsonString else { return }
        
        let activity = DeviceActivityName(jsonIdentifier)
        await centerManager.stopMonitoring([activity])

        // Also clear persisted resumeAt/suspendedAt.
        if var stored = (try? await blockItemPersistenceManager.fetch(by: blockItem.id)) {
            switch stored.type {
            case .scheduled(let start, let end, let isActive, _, _):
                stored.type = .scheduled(startTime: start, endTime: end, isActive: isActive, isPaused: false)
            case .duration(let duration, _, _, let endDate):
                stored.type = .duration(duration, suspendedAt: nil, suspendedUntil: nil, endDate: endDate)
            }
            try await blockItemPersistenceManager.editBlockItem(blockItem: stored)
        }
    }

    /// Register a DeviceActivity interval at the minute containing `resumeAt`.
    /// When the system wakes the DeviceActivity extension at that minute, your handler
    /// should detect the activity identifier and call `shieldManager.block(...)`.
    private func registerResumeMonitoring(blockItemID: UUID, resumeAt: Date) async throws {
        // Make an identifier with the UUID of the same block item but mark it as a resumption block.
        let identifier = CodableActivityIdentifier(blockItemID: blockItemID, blockType: .resumption)
        
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
