//
//  BlockItemExtensionStore.swift
//  FocusTime
//
//  Created by Maksym Horobets on 08.08.2025.
//

import os.log
import SwiftData
import Foundation

// MARK: Do not isolate this declaration to any actor.
final class BlockItemExtensionStore {
    private let logger: Logger?
    let context: ModelContext
    
    init(
        logger: Logger?,
        context: ModelContext
    ) {
        self.logger = logger
        self.context = context
    }
    
    func fetchBlockItem(id: UUID) -> BlockItem? {
        let fetchDescriptor = FetchDescriptor<BlockItem>(
            predicate: #Predicate<BlockItem> { $0.id == id }
        )
        
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            logger?.error("Failed to fetch BlockItem: \(error.localizedDescription)")
            return nil
        }
    }
    
    func updateSessionState(for blockItem: BlockItem, isActive: Bool) {
        switch blockItem.type {
        case .scheduled(let startTime, let endTime, _, let isPaused, let suspendedUntil):
            // Only update isActive, keep pause state intact.
            blockItem.type = .scheduled(
                startTime: startTime,
                endTime: endTime,
                isActive: isActive,
                isPaused: isPaused,
                suspendedUntil: suspendedUntil
            )
        case .duration(let duration, let suspendedAt, let suspendedUntil, let endDate):
            blockItem.type = .duration(
                duration: duration,
                suspendedAt: suspendedAt,
                suspendedUntil: suspendedUntil,
                endDate: isActive ? endDate : nil // Set or clear endDate based on activity.
            )
        }
        saveContext()
    }
    
    func suspendSession(for blockItem: BlockItem, at suspensionDate: Date, until resumeDate: Date, newEndDate: Date?) {
        switch blockItem.type {
        case .scheduled(let startTime, let endTime, let isActive, _, _):
            blockItem.type = .scheduled(
                startTime: startTime,
                endTime: endTime,
                isActive: isActive,
                isPaused: true,
                suspendedUntil: resumeDate
            )
        case .duration(let duration, _, _, _):
            blockItem.type = .duration(
                duration: duration,
                suspendedAt: suspensionDate,
                suspendedUntil: resumeDate,
                endDate: newEndDate // The end date is extended by the suspension duration.
            )
        }
        saveContext()
    }
    
    func resumeSession(for blockItem: BlockItem) {
        switch blockItem.type {
        case .scheduled(let startTime, let endTime, let isActive, _, _):
            blockItem.type = .scheduled(
                startTime: startTime,
                endTime: endTime,
                isActive: isActive,
                isPaused: false,
                suspendedUntil: nil
            )
        case .duration(let duration, _, _, let endDate):
            // When resuming, clear suspension dates and keep the existing endDate.
            blockItem.type = .duration(
                duration: duration,
                suspendedAt: nil,
                suspendedUntil: nil,
                endDate: endDate
            )
        }
        saveContext()
    }
    
    func setItemIsCancelled(_ isCancelled: Bool, for blockItem: BlockItem) {
        blockItem.isCancelled = isCancelled
        saveContext()
    }
    
    func delete(model blockItem: BlockItem) {
        context.delete(blockItem)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            logger?.error("Failed to save ModelContext: \(error.localizedDescription)")
        }
    }
}
