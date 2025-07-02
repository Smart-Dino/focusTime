//
//  ScheduleStore.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import Foundation
import SwiftData

@ModelActor
actor ScheduleStore: DataSource {
    
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
        guard let model = modelContext.model(for: id) as? Schedule else {
            throw DataSourceError.notFound
        }
        modelContext.delete(model)
        try modelContext.save()
    }
    
    func fetch() throws -> [ProtectedSchedule] {
        try modelContext
            .fetch(FetchDescriptor<Schedule>())
            .map { ProtectedSchedule(from: $0) }
    }
    
    func fetch(id: PersistentIdentifier) throws -> ProtectedSchedule? {
        let descriptor = FetchDescriptor<Schedule>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let model = try? modelContext.fetch(descriptor).first else {
            throw DataSourceError.notFound
        }
        
        return ProtectedSchedule(from: model)
    }
    
    func fetch(descriptor: FetchDescriptor<Schedule>) throws -> [ProtectedSchedule] {
        try modelContext.fetch(descriptor).map { ProtectedSchedule(from: $0) }
    }
    
    func updateFields(id: PersistentIdentifier, using updates: (Schedule) -> Void) throws {
        let descriptor = FetchDescriptor<Schedule>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let model = try? modelContext.fetch(descriptor).first else {
            throw DataSourceError.notFound
        }
        
        updates(model)
        
        try modelContext.save()
    }
    
    func eraseAllData() throws {
        try modelContext.delete(model: Schedule.self)
    }
}
