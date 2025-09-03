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
        guard blockItem.persistentModelID != nil else {
            throw DeviceActivityRegistrarError.activityNotFound
        }
        guard let secondsLeft = blockItem.type.secondsToIntervalEndIfShouldBeRunning(), secondsLeft > seconds else {
            throw DeviceActivityRegistrarError.cannotSuspend
        }
        
        let suspensionDate = await clock.now
        let suspendedUntil = suspensionDate.addingTimeInterval(TimeInterval(seconds))
    
        var updatedBlockItem = blockItem
        
        // For duration blocks, we must stop the existing "end trigger" activity.
        if case .duration = blockItem.type {
            let activity = try await getActivityForSchedule(blockItem)
            await centerManager.stopMonitoring([activity])
        }
        
        switch blockItem.type {
        case .scheduled(let startTime, let endTime, let isActive, _, _):
            updatedBlockItem.type = .scheduled(
                startTime: startTime,
                endTime: endTime,
                isActive: isActive,
                isPaused: true,
                suspendedUntil: suspendedUntil
            )
            
        case .duration(let duration, _, _, let endDate):
            guard let endDate else {
                throw DeviceActivityRegistrarError.couldNotExtractDatePoints
            }
            updatedBlockItem.type = .duration(
                duration: duration,
                suspendedAt: suspensionDate,
                suspendedUntil: suspendedUntil,
                endDate: endDate.addingTimeInterval(TimeInterval(seconds))
            )
        }
        
        try await blockItemPersistenceManager.editBlockItem(blockItem: updatedBlockItem)
        
        try await shieldManager.unblock()
        try await registerResumeMonitoring(blockItemID: blockItem.id, resumeAt: suspendedUntil)
    }
    
    func cancelScheduledResume(for blockItem: ProtectedBlockItem) async throws {
        guard blockItem.persistentModelID != nil else { throw DeviceActivityRegistrarError.noPersistentItem }
        
        let activityIdentifier = CodableActivityIdentifier(blockItemID: blockItem.id, blockType: .resumption)
        guard let jsonIdentifier = activityIdentifier.jsonString else { return }
        let activity = DeviceActivityName(jsonIdentifier)
        await centerManager.stopMonitoring([activity])

        var updatedBlockItem = blockItem
        switch blockItem.type {
        case .scheduled(let start, let end, let isActive, _, _):
            updatedBlockItem.type = .scheduled(startTime: start, endTime: end, isActive: isActive, isPaused: false)
        case .duration(let duration, _, _, let endDate):
            updatedBlockItem.type = .duration(duration: duration, suspendedAt: nil, suspendedUntil: nil, endDate: endDate)
        }

        try await blockItemPersistenceManager.editBlockItem(blockItem: updatedBlockItem)
    }
    
    func removeTempBlockRelated(to blockItem: ProtectedBlockItem) async throws {
        guard blockItem.persistentModelID != nil else { throw DeviceActivityRegistrarError.noPersistentItem }
        
        let activityIdentifier = CodableActivityIdentifier(blockItemID: blockItem.id, blockType: .regularTemp)
        guard let jsonIdentifier = activityIdentifier.jsonString else { return }
        let activity = DeviceActivityName(jsonIdentifier)
        await centerManager.stopMonitoring([activity])
    }

    private func registerResumeMonitoring(blockItemID: UUID, resumeAt: Date) async throws {
        let identifier = CodableActivityIdentifier(blockItemID: blockItemID, blockType: .resumption)
        guard let jsonActivity = identifier.jsonString else { return }
        let activityName = DeviceActivityName(jsonActivity)
        
        let startComponents = try TimeComponents(from: resumeAt).dateComponents
        let endDate = resumeAt.addingTimeInterval(TimeInterval(Self.fallbackIntervalSeconds))
        let endComponents = try TimeComponents(from: endDate).dateComponents
        
        let schedule = DeviceActivitySchedule(intervalStart: startComponents, intervalEnd: endComponents, repeats: false)
        
        try await centerManager.startMonitoring(activityName, during: schedule)
    }
}
