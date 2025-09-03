//
//  DeviceActivityHandler.swift
//  FocusTimeActivityMonitor
//
//  Created by Maksym Horobets on 04.07.2025.
//

import os.log
import SwiftData
import Foundation
import DeviceActivity

// This handler is used in the DeviceActivityMonitorExtension.
// This is why it is structured the way it is.
// It has to inherit the caller's execution context - hence why it is not an actor.
// MARK: Do not isolate this declaration to any actor.
struct DeviceActivityHandler: Sendable {
    private let logger: Logger?
    private let container: ModelContainer
    private let shieldManager: ShieldManager
    
    init(
        logger: Logger?,
        container: ModelContainer,
        shieldManager: ShieldManager
    ) {
        self.logger = logger
        self.container = container
        self.shieldManager = shieldManager
    }
    
    // MARK: - Public API
    
    func handleBlockingStart(for activity: DeviceActivityName) async {
        guard let activityIdentifier = CodableActivityIdentifier(from: activity) else {
            await fallbackExit(for: activity, unblockApps: false) // If related identifier cannot be recreated - remove activity.
            return
        }
        let store = BlockItemExtensionStore(logger: logger, context: ModelContext(container))
        
        guard let blockItem = store.fetchBlockItem(id: activityIdentifier.blockItemID) else {
            await fallbackExit(for: activity, unblockApps: false) // If related block item does not exist - remove activity.
            return
        }
        
        if blockItem.isCancelled {
            store.setItemIsCancelled(false, for: blockItem)
            return
        }
        
        switch activityIdentifier.blockType {
        case .regular, .regularTemp:
            await handleInitialBlocking(for: blockItem, with: activity, in: store)
        case .resumption:
            // Pass the activity down so it can be stopped.
            await handleResumption(for: blockItem, with: activity, in: store)
        }
    }
    
    func handleBlockingEnd(for activity: DeviceActivityName) async {
        guard let activityIdentifier = CodableActivityIdentifier(from: activity) else {
            await fallbackExit(for: activity) // If related identifier cannot be recreated - remove activity.
            return
        }
        guard activityIdentifier.blockType == .regular || activityIdentifier.blockType == .regularTemp else { return }
        
        let store = BlockItemExtensionStore(logger: logger, context: ModelContext(container))
        guard let blockItem = store.fetchBlockItem(id: activityIdentifier.blockItemID) else {
            await fallbackExit(for: activity) // If the item cannot be found anymore - remove activity.
            return
        }
        
        if blockItem.isCancelled {
            store.setItemIsCancelled(false, for: blockItem)
            return
        }
        
        await unblockAndDeactivateSession(for: blockItem, in: store)
    }
    
    // MARK: - Private Handlers
    
    private func handleInitialBlocking(for blockItem: BlockItem, with activity: DeviceActivityName, in store: BlockItemExtensionStore) async {
        switch blockItem.type {
        case .scheduled:
            guard blockItem.days.contains(Weekday.currentDay) else { return }
            await blockAndActivateSession(for: blockItem, in: store)
            
        case .duration(_, _, _, let endDate):
            await handleDurationUnblocking(for: blockItem, in: store, endDate: endDate)
            DeviceActivityCenter().stopMonitoring([activity])
        }
    }
    
    // The signature now accepts the activity.
    private func handleResumption(for blockItem: BlockItem, with activity: DeviceActivityName, in store: BlockItemExtensionStore) async {
        switch blockItem.type {
        case .scheduled(_, _, _, _, let suspendedUntil):
            if let suspendedUntil {
                let offset = Int(suspendedUntil.timeIntervalSinceNow)
                await self.offset(seconds: offset)
            }
            
            await blockAndActivateSession(for: blockItem, in: store, isResuming: true)
            
        case .duration(_, _, let suspendedUntil, _):
            if let suspendedUntil {
                let offset = Int(suspendedUntil.timeIntervalSinceNow)
                await self.offset(seconds: offset)
            }
            
            await resumeDurationBlocking(for: blockItem, in: store)
        }
        // Once it has fired and we've handled it, stop monitoring it
        // to free up the name for the next suspension cycle.
        DeviceActivityCenter().stopMonitoring([activity])
    }
    
    private func resumeDurationBlocking(for blockItem: BlockItem, in store: BlockItemExtensionStore) async {
        guard case let .duration(_, _, suspendedUntil, endDate) = blockItem.type, let endDate else {
            logger?.warning("Attempted to resume a duration block that has no end date.")
            return
        }
        
        if let suspendedUntil {
            let offset = Int(suspendedUntil.timeIntervalSinceNow)
            await self.offset(seconds: offset)
        }

        do {
            try await shieldManager.block(specific: blockItem.blockedContent)
            
            let intervalStart = try TimeComponents(from: endDate).dateComponents
            let intervalEnd = intervalStart.adding(seconds: SharedAppValues.activityRegistrarFallbackInterval)
            let schedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: false)
            
            guard let activityName = CodableActivityIdentifier(blockItemID: blockItem.id, blockType: .regular).jsonString else { return }
            let deviceActivityName = DeviceActivityName(activityName)
            
            try DeviceActivityCenter().startMonitoring(deviceActivityName, during: schedule)

            store.resumeSession(for: blockItem)

        } catch {
            logger?.error("Failed to re-register and block on resumption: \(error.localizedDescription)")
        }
    }
    
    private func handleDurationUnblocking(for blockItem: BlockItem, in store: BlockItemExtensionStore, endDate: Date?) async {
        if let endDate {
            let offset = Int(endDate.timeIntervalSinceNow)
            await self.offset(seconds: offset)
        }
        await unblockAndDeactivateSession(for: blockItem, in: store)

        if blockItem.isTemporary != nil {
            store.delete(model: blockItem)
        }
    }
    
    private func blockAndActivateSession(for blockItem: BlockItem, in store: BlockItemExtensionStore, isResuming: Bool = false) async {
        do {
            try await shieldManager.block(specific: blockItem.blockedContent)
            if isResuming {
                store.resumeSession(for: blockItem)
            } else {
                store.updateSessionState(for: blockItem, isActive: true)
            }
        } catch {
            logger?.error("Failed to block content: \(error.localizedDescription)")
        }
    }
    
    private func unblockAndDeactivateSession(for blockItem: BlockItem, in store: BlockItemExtensionStore) async {
        do {
            try await shieldManager.unblock()
            store.updateSessionState(for: blockItem, isActive: false)
        } catch {
            logger?.error("Failed to unblock content: \(error.localizedDescription)")
        }
    }
    
    private func offset(seconds: Int) async {
        var counter = 0
        while counter < seconds {
            // I decided not to do Task.sleep(for: .seconds(seconds))) so that the system sees activity
            // in the extension and does not kill it.
            // Basically this solution is safer.
            try? await Task.sleep(for: .seconds(1), tolerance: SharedAppValues.timerLeeway)
            counter += 1
        }
    }
    
    private func fallbackExit(for activity: DeviceActivityName, unblockApps: Bool = false) async {
        logger?.warning("Executing fallback for activity '\(activity.rawValue)'. unblockApps: \(unblockApps)")
        
        logger?.info("Stopping monitoring for activity: \(activity.rawValue)")
        DeviceActivityCenter().stopMonitoring([activity])
        
        if unblockApps {
            logger?.info("Attempting to unblock all shielded content as part of fallback.")
            
            do {
                try await shieldManager.unblock()
                logger?.info("Successfully unblocked content for activity: \(activity.rawValue)")
            } catch {
                logger?.error("Failed to unblock content during fallback for activity '\(activity.rawValue)': \(error.localizedDescription)")
            }
        }
    }
}
