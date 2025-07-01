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
    
    func insert(_ item: ProtectedSchedule) throws {
        let container = modelContainer
        let context = ModelContext(container) // Create a separate, non-main context to write to.
        let modelItem = Schedule(from: item) // Convert to model instance.
        context.insert(modelItem)
        try context.save() // Apply the context to the DB.
    }
    
    func delete(id: PersistentIdentifier) throws {
        // Fetch the item by id and delete it from the context, then save.
        guard let item = try fetch(id: id) else { throw DataSourceError.notFound }
        modelContext.delete(item)
        try modelContext.save()
    }
    
    func fetch() throws -> [Schedule] {
        try modelContext.fetch(FetchDescriptor<Schedule>())
    }
    
    func fetch(id: PersistentIdentifier) throws -> Schedule? {
        try modelContext.fetch(
            FetchDescriptor(predicate: #Predicate<Schedule>{ $0.id == id })
        ).first
    }
    
    func fetch(descriptor: FetchDescriptor<Schedule>) throws -> [Schedule] {
        try modelContext.fetch(descriptor)
    }
    
    func updateFields(id: PersistentIdentifier, using updates: (Schedule) -> Void) throws {
        // Fetch the item by id for update
        guard let fetchedItem = try fetch(id: id) else {
            throw DataSourceError.notFound
        }
        
        updates(fetchedItem)
        
        try modelContext.save()
    }
    
    func eraseAllData() throws {
        try modelContext.delete(model: Schedule.self)
    }
}
