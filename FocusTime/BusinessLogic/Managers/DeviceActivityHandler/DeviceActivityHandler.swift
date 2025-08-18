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
// But it cannot be a class due to Task sendability issues.
nonisolated struct DeviceActivityHandler: Sendable {
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
    
    func handleBlockingStart(for activity: DeviceActivityName) async {
        guard let activityIdentifier = CodableActivityIdentifier(from: activity) else { return }
        // Create context from scratch because using mainContext in a
        // non-isolated to MainActor environment is not allowed.
        let store = BlockItemExtensionStore(logger: logger, context: ModelContext(container))
        
        let blockItem = store.fetchBlockItem(id: activityIdentifier.blockItemID)
        
        // Make sure we have our block item.
        guard let blockItem else { return }
        
        switch blockItem.type {
        case .scheduled(_, let endTime, _, _):
            await handleRegularBlocking(blockItem: blockItem,
                                        activity: activity,
                                        activityIdentifier: activityIdentifier,
                                        endTime: endTime,
                                        store: store)
        case .duration:
            switch activityIdentifier.actionType {
            case .fallback, .regular:
                await handleDurationUnblocking(for: blockItem, store: store)
            case .resumption:
                handleResumptionBlocking(for: blockItem, store: store)
            }
            // We don't need to handle the end of the interval anymore.
            DeviceActivityCenter().stopMonitoring([activity])
        }
        
    }
    
    func handleBlockingEnd(for activity: DeviceActivityName) async {
        do {
            guard let activityIdentifier = CodableActivityIdentifier(from: activity) else { return }
            
            // If this is fallback's end - ignore it.
            // Fallback schedules run at blockingStart and finish there respectively.
            guard activityIdentifier.actionType != .fallback else { return }
            
            // Create context from scratch because using mainContext in a
            // non-isolated to MainActor environment is not allowed.
            let store = BlockItemExtensionStore(logger: logger, context: ModelContext(container))
            
            let blockItem = store.fetchBlockItem(id: activityIdentifier.blockItemID)
            
            try await shieldManager.unblock()
            
            guard let blockItem else { return }
            store.setSessionIsActive(for: blockItem, isActive: false)
        } catch {
            logger?.error("Failure in \(#function): \(error.localizedDescription)")
        }
    }
    
    private func handleRegularBlocking(
        blockItem: BlockItem,
        activity: DeviceActivityName,
        activityIdentifier: CodableActivityIdentifier,
        endTime endTimeComponent: TimeComponents,
        store: BlockItemExtensionStore
    ) async {
        // Make sure the current day is the block day.
        guard blockItem.days.contains(Weekday.currentDay) else { return }
        
        // Block user's selections.
        let selection = blockItem.blockedContent
        do {
            try await shieldManager.block(specific: selection)
            store.setSessionIsActive(for: blockItem, isActive: true)
        } catch {
            logger?.error("Failed to block in \(#function): \(error.localizedDescription)")
        }
        
        if case .fallback = activityIdentifier.actionType {
            // TimeComponents has an accuracy of a minute.
            // Hence why we are comparing it directly - we have a whole minute to detect the match.
            do {
                while try TimeComponents(from: .now) != endTimeComponent {
                    try await Task.sleep(nanoseconds: 5_000_000_000)
                } // Unfortunately sleeping task for a long time causes extension to close before unblock.
                
                try await shieldManager.unblock()
                store.setSessionIsActive(for: blockItem, isActive: false)
            } catch {
                logger?.error("Failed to unblock in \(#function) while handling fallback: \(error.localizedDescription)")
            }
            
        }
    }
    
    /// Called when a one-time blocking interval ends.
    private func handleDurationUnblocking(for blockItem: BlockItem, store: BlockItemExtensionStore) async {
        // Unblock.
        do {
            try await shieldManager.unblock()
        } catch {
            logger?.error("Failed to unblock in handleDurationUnblocking: \(error.localizedDescription)")
        }
        
        // Reset duration values if this BlockItem was created as duration block.
        guard case .duration = blockItem.type else { return }
        
        // If it is temporary then we just delete it.
        if !blockItem.isTemporary {
            store.setSessionIsActive(for: blockItem, isActive: false)
        } else {
            store.delete(model: blockItem)
        }
    }
    
    private func handleResumptionBlocking(for blockItem: BlockItem, store: BlockItemExtensionStore) async {
        // Block user's selections again.
        let selection = blockItem.blockedContent
        do {
            try await shieldManager.block(specific: selection)
            store.setSessionIsActive(for: blockItem, isActive: true)
        } catch {
            logger?.error("Failed to block in \(#function): \(error.localizedDescription)")
        }
    }
}

