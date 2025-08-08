//
//  BlockItemExtensionStore.swift
//  FocusTime
//
//  Created by Maksym Horobets on 08.08.2025.
//

import os.log
import SwiftData
import Foundation

nonisolated final class BlockItemExtensionStore {
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
    
    func setSessionIsActive(for blockItem: BlockItem, isActive: Bool) {
        switch blockItem.type {
        case .scheduled(let startTime, let endTime, _):
            blockItem.type = .scheduled(startTime: startTime, endTime: endTime, isActive: isActive)
        case .duration(let duration, _, _, _):
            if isActive {
                break // Duration start time is set in the main app upon duration block start.
            } else {
                blockItem.type = .duration(
                    duration,
                    startedAt: nil,
                    suspendedAt: nil,
                    timeLeft: duration
                )
            }
        }
        
        saveContext()
    }
    
    func delete(model blockItem: BlockItem) {
        context.delete(blockItem)
        saveContext()
    }
    
    private func saveContext() {
        // Save changes.
        do {
            try context.save()
        } catch {
            logger?.error("Failed to save ModelContext: \(error.localizedDescription)")
        }
    }
}
