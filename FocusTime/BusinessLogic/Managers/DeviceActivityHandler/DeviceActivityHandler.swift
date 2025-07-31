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
    
    func handleBlockingStart(for activity: DeviceActivityName) async {
        guard let activityIdentifier = CodableActivityIdentifier(from: activity) else { return }
        
        let blockItem = fetchBlockItem(id: activityIdentifier.blockItemID)
        
        // Make sure we have our schedule.
        guard let blockItem else { return }
        
        switch blockItem.type {
        case .scheduled(_, let endTime):
            await handleRegularBlocking(blockItem: blockItem,
                                        activity: activity,
                                        activityIdentifier: activityIdentifier,
                                        endTime: endTime)
        case .oneTime:
            await handleDurationUnblocking(for: blockItem)
            // We don't need to handle the end of the interval anymore.
            DeviceActivityCenter().stopMonitoring([activity])
        }
        
    }
    
    /// Called when a one-time blocking interval ends.
    private func handleDurationUnblocking(for blockItem: BlockItem) async {
        // Unblock.
        do {
            try await shieldManager.unblock()
        } catch {
            logger?.error("Failed to unblock in handleDurationUnblocking: \(error.localizedDescription)")
        }
        
        // Reset duration values.
        guard case .oneTime(let duration, _, _, _) = blockItem.type else { return }
        blockItem.type = .oneTime(
            duration,
            startedAt: nil,
            suspendedAt: nil,
            timeLeft: duration
        )
        
        // Save changes.
        do {
            try ModelContext(container).save()
        } catch {
            logger?.error("Failed to save ModelContext in handleDurationUnblocking: \(error.localizedDescription)")
        }
    }
    
    private func handleRegularBlocking(
        blockItem: BlockItem,
        activity: DeviceActivityName,
        activityIdentifier: CodableActivityIdentifier,
        endTime endTimeComponent: TimeComponents
    ) async {
        // Make sure the current day is the block day.
        guard blockItem.days.contains(Weekday.currentDay) else { return }
        
        // Block user's selections.
        let selection = blockItem.blockedContent
        do {
            try await shieldManager.block(specific: selection)
        } catch {
            logger?.error("Failed to block in handleRegularBlocking: \(error.localizedDescription)")
        }
        
        // Sendability workaround since DeviceActivityName is not sendable.
        let stringActivityName = activity.rawValue
        
        if activityIdentifier.isFallback {
            // TimeComponents has an accuraccy of a minute.
            // Hence why we are comparing it direclty - we have a whole minute to detect the match.
            while TimeComponents(from: .now) != endTimeComponent {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
            } // Unfortunately sleeping task for a long time causes extension to close before unblock.
            
            do {
                try await shieldManager.unblock()
            } catch {
                logger?.error("Failed to unblock in handleRegularBlocking fallback handling: \(error.localizedDescription)")
            }
            
            DeviceActivityCenter()
                .stopMonitoring(
                    [DeviceActivityName(stringActivityName)]
                )
            
        }
    }
    
    func handleBlockingEnd() async {
        do {
            try await shieldManager.unblock()
        } catch {
            logger?.error("Failed to unblock in handleBlockingEnd: \(error.localizedDescription)")
        }
    }
    
    private func fetchBlockItem(id: UUID) -> BlockItem? {
        // Create context from scratch because using mainContext in a
        // non-isolated to MainActor environment is not allowed.
        let context = ModelContext(container)
        
        // Fetch the schedule.
        let fetchDescriptor = FetchDescriptor<BlockItem>(
            predicate: #Predicate<BlockItem> { $0.id == id }
        )
        
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            logger?.error("Failed to fetch BlockItem in fetchBlockItem: \(error.localizedDescription)")
            return nil
        }
    }
}

