//
//  ScheduleStore.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import Foundation
import SwiftData

@ModelActor
actor ScheduleStore: PersistenceStore {
    
    @discardableResult
    func insert(_ item: ProtectedSchedule) throws -> PersistentIdentifier {
        let model = Schedule(from: item) // Convert to model instance.
        modelContext.insert(model)
        try modelContext.save() // Apply the context to the DB.
        return model.persistentModelID
    }
    
    @discardableResult
    func insertBatch(_ items: [ProtectedSchedule]) throws -> Set<PersistentIdentifier> {
        var ids = Set<PersistentIdentifier>()
        for item in items {
            let model = Schedule(from: item)
            modelContext.insert(model)
            ids.insert(model.persistentModelID)
        }
        try modelContext.save()
        return ids
    }
    
    func delete(id: PersistentIdentifier) throws {
        let model = try fetchForID(id)
        modelContext.delete(model)
        try modelContext.save()
    }
    
    func fetch() throws -> [ProtectedSchedule] {
        try modelContext
            .fetch(FetchDescriptor<Schedule>())
            .map { ProtectedSchedule(from: $0) }
    }
    
    func fetch(page: Int = 0, amountPerPage: Int = 50) throws -> [ProtectedSchedule] {
        let alreadyFetched = page * amountPerPage
        
        var descriptor = FetchDescriptor<Schedule>()
        descriptor.fetchLimit = amountPerPage
        descriptor.fetchOffset = alreadyFetched
        
        let fetched = try modelContext.fetch(descriptor)
        
        return fetched.map {
            ProtectedSchedule(from: $0)
        }
    }
    
    func fetch(id: PersistentIdentifier) throws -> ProtectedSchedule? {
        let model = try fetchForID(id)
        
        return ProtectedSchedule(from: model)
    }
    
    func fetch(descriptor: FetchDescriptor<Schedule>) throws -> [ProtectedSchedule] {
        try modelContext.fetch(descriptor).map { ProtectedSchedule(from: $0) }
    }
    
    func updateFields(id: PersistentIdentifier, using updates: (Schedule) -> Void) throws {
        let model = try fetchForID(id)
        
        updates(model)
        
        try modelContext.save()
    }
    
    func eraseAllData() throws {
        try modelContext.delete(model: Schedule.self)
    }
    
    func eraseAllData() throws {
        try modelContext.delete(model: Schedule.self)
    }
}

// MARK: Helpers
extension ScheduleStore {
    func fetchForID(_ id: PersistentIdentifier) throws -> Schedule {
        let descriptor = FetchDescriptor<Schedule>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let model = try? modelContext.fetch(descriptor).first else {
            throw PersistenceStoreError.notFound
        }
        
        return model
    }
}

