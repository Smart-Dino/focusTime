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
    // MARK: - Constants & Dependencies
    static let fallbackIntervalSeconds = SharedAppValues.activityRegistrarFallbackInterval
    
    let clock: Clock
    let calendar: Calendar
    let centerManager: DeviceActivityCenterManager
    let shieldManager: ShieldManager
    let blockItemPersistenceManager: BlockItemPersistenceManager
    
    init(
        clock: Clock = SystemClock(),
        calendar: Calendar = .current,
        centerManager: DeviceActivityCenterManager = LiveDeviceActivityCenterManager(),
        blockItemPersistenceManager: BlockItemPersistenceManager,
        shieldManager: ShieldManager
    ) {
        self.clock = clock
        self.calendar = calendar
        self.centerManager = centerManager
        self.blockItemPersistenceManager = blockItemPersistenceManager
        self.shieldManager = shieldManager
    }
    
    // MARK: - Public API (conforms to DeviceActivityRegistrar)
    var trackedActivities: [CodableActivityIdentifier] {
        get async {
            await centerManager.activities
                .compactMap { CodableActivityIdentifier(from: $0) }
                .filter { $0.blockType == .regular }
        }
    }
    
    func checkAuth() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }
    
    func registerActivity(during blockItem: ProtectedBlockItem) async throws {
        try await checkAuth()
        
        switch blockItem.type {
        case .scheduled(let startTime, let endTime, _, _, _):
            try await registerRegularActivity(for: blockItem, startTime: startTime, endTime: endTime)
            try await startActivityIfRegisteredDuringIntervalWindow(item: blockItem)
        case .duration(let duration, _, _, _):
            try await validateNoOverlapForDurationBlocking(proposedDuration: duration.rawValue)
            try await registerDurationActivity(for: blockItem)
        }
    }
    
    func unregisterActivity(during blockItem: ProtectedBlockItem) async throws {
        // Stop the system-level monitoring.
        let activity = try await getActivityForSchedule(blockItem)
        await centerManager.stopMonitoring([activity])
        
        // If the block had any related temp blocks to it - remove them.
        try await cleanupTemporaryBlock(relatedTo: blockItem.id)
    }
    
    func suspendActivity(for blockItem: ProtectedBlockItem) async throws {
        let suspensionDate = await clock.now
        guard let persistentModelID = blockItem.persistentModelID else {
            throw DeviceActivityRegistrarError.activityNotFound
        }
        
        let activity = try await getActivityForSchedule(blockItem)
        var stored = try await blockItemPersistenceManager.fetch(by: persistentModelID)
        
        switch stored.type {
        case .scheduled(let startTime, let endTime, let isActive, _, _):
            stored.type = .scheduled(startTime: startTime, endTime: endTime, isActive: isActive, isPaused: true)
            try await blockItemPersistenceManager.editBlockItem(blockItem: stored)
            
            try await shieldManager.unblock()
        case .duration(let duration, _, _, let endDate):
            guard let endDate else {
                throw DeviceActivityRegistrarError.couldNotExtractDatePoints
            }
            
            // Store suspension moment and keep endDate unchanged.
            stored.type = .duration(duration: duration, suspendedAt: suspensionDate, suspendedUntil: nil, endDate: endDate)
            try await blockItemPersistenceManager.editBlockItem(blockItem: stored)
            
            try await shieldManager.unblock()
            await centerManager.stopMonitoring([activity])
        }
    }
    
    // The activity isn't always 100% accurate since DeviceActivitySchedule does not account for seconds.
    func resumeActivity(for blockItem: ProtectedBlockItem) async throws {
        let resumptionDate = await clock.now
        guard let persistentModelID = blockItem.persistentModelID else {
            throw DeviceActivityRegistrarError.activityNotFound
        }
        
        var stored = try await blockItemPersistenceManager.fetch(by: persistentModelID)
        
        switch stored.type {
        case .scheduled(let startTime, let endTime, let isActive, _, _):
            stored.type = .scheduled(startTime: startTime, endTime: endTime, isActive: isActive, isPaused: false)
            try await blockItemPersistenceManager.editBlockItem(blockItem: stored)
            
            try await shieldManager.block(specific: stored.blockedContent)
            
        case .duration(let duration, let suspendedAt, _, let endDate):
            guard let endDate else { throw DeviceActivityRegistrarError.activityNotFound }
            // If suspended, slide the end date forward by pause duration so remaining time stays consistent.
            let adjustedEndDate = Self.adjustedEndDate(endDate: endDate, suspendedAt: suspendedAt, resumedAt: resumptionDate)
            let remainingSeconds = max(0, Int(adjustedEndDate.timeIntervalSince(resumptionDate)))
            
            stored.type = .duration(duration: duration, suspendedAt: nil, suspendedUntil: nil, endDate: adjustedEndDate)
            try await blockItemPersistenceManager.editBlockItem(blockItem: stored)
            
            // Re-register device activity for the remaining duration.
            try await registerDurationActivity(for: stored, forcedDuration: remainingSeconds)
        }
    }
    
    func isActivityRegistered(for blockItem: ProtectedBlockItem) async throws -> Bool {
        guard blockItem.persistentModelID != nil else { throw DeviceActivityRegistrarError.activityNotFound }
        return (try? await getActivityForSchedule(blockItem)) != nil
    }
    
    func cancelIfRunning(_ blockItem: ProtectedBlockItem) async throws {
        try await shieldManager.unblock()
        try? await cleanupTemporaryBlock(relatedTo: blockItem.id)
        
        // If the block itself is temporary, just delete it and we're done.
        if blockItem.isTemporary != nil {
            try await cancelScheduledResume(for: blockItem)
            try await blockItemPersistenceManager.delete(blockItem: blockItem)
            return
        }
        
        // This is a permanent block - clean up its associated temporary block first.
        try await cleanupTemporaryBlock(relatedTo: blockItem.id)
        
        var mutableBlockItem = blockItem
        switch mutableBlockItem.type {
        case .scheduled(let startTime, let endTime, _, let isPaused, let suspendedUntil):
            // Set isActive to false to stop the current session without affecting future runs.
            mutableBlockItem.isCancelled = true
            mutableBlockItem.type = .scheduled(
                startTime: startTime,
                endTime: endTime,
                isActive: false,
                isPaused: isPaused,
                suspendedUntil: suspendedUntil
            )
            
        case .duration(let duration, let suspendedAt, let suspendedUntil, _):
            mutableBlockItem.type = .duration(
                duration: duration,
                suspendedAt: suspendedAt,
                suspendedUntil: suspendedUntil,
                endDate: nil
            )
            try await unregisterActivity(during: mutableBlockItem)
        }
        
        try await blockItemPersistenceManager.editBlockItem(blockItem: mutableBlockItem)
        try await cancelScheduledResume(for: mutableBlockItem)
    }
    
    func unregisterAll() async {
        await centerManager.stopMonitoring()
    }
}

