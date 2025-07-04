//
//  RelationshipCoordinator.swift
//  FocusTime
//
//  Created by Maksym Horobets on 03.07.2025.
//

import SwiftData
import Foundation

@ModelActor // Serialize on ModelActor to avoid any database corruptions.
actor RelationshipCoordinator {
    func relate(blockItemID: PersistentIdentifier, scheduleID: PersistentIdentifier) throws {
        let blockItemDescriptor = FetchDescriptor<BlockItem>(
            predicate: #Predicate { $0.id == blockItemID }
        )
        let scheduleDescriptor = FetchDescriptor<Schedule>(
            predicate: #Predicate { $0.id == scheduleID }
        )
        
        // Fetch items.
        guard let blockItem = try modelContext.fetch(blockItemDescriptor).first else {
            throw PersistenceStoreError.notFound
        }
        guard let schedule = try modelContext.fetch(scheduleDescriptor).first else {
            throw PersistenceStoreError.notFound
        }
        
        // Make sure the array exits.
        if blockItem.schedules == nil {
            blockItem.schedules = []
        }
        
        // If the relationship between the two objects does not exist.
        if blockItem.schedules?.contains(where: { $0.id == schedule.id }) != true {
            // Add relationship.
            blockItem.schedules!.append(schedule)
        } else {
            throw PersistenceStoreError.alreadyRelated
        }
        
        // Save changes.
        try modelContext.save()
    }
    
    func breakRelationship(blockItemID: PersistentIdentifier, scheduleID: PersistentIdentifier) throws {
        let blockItemDescriptor = FetchDescriptor<BlockItem>(
            predicate: #Predicate { $0.id == blockItemID }
        )
        let scheduleDescriptor = FetchDescriptor<Schedule>(
            predicate: #Predicate { $0.id == scheduleID }
        )
        
        // Fetch items.
        guard let blockItem = try modelContext.fetch(blockItemDescriptor).first else {
            throw PersistenceStoreError.notFound
        }
        guard let schedule = try modelContext.fetch(scheduleDescriptor).first else {
            throw PersistenceStoreError.notFound
        }
        
        // Remove the schedule if it exists.
        if let index = blockItem.schedules?.firstIndex(where: { $0.id == schedule.id }) {
            blockItem.schedules?.remove(at: index)
        }
        
        // Save changes.
        try modelContext.save()
    }
}
