//
//  ScheduleStore.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import Foundation
import SwiftData

@MainActor
final class ScheduleStore: DataSource {
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init() {
        let config = ModelConfiguration(groupContainer: .identifier(appGroupIdentifier))
        let container = try! ModelContainer(
            for: BlockItem.self,
            configurations: config
        )
        let context = container.mainContext
        self.modelContainer = container
        self.modelContext = context
    }
    
    @GlobalSourceActor func insert(_ item: ProtectedSchedule) throws {
        let container = modelContainer
        let context = ModelContext(container) // Create a separate, non-main context to write to.
        let modelItem = Schedule(from: item) // Convert to model instance.
        context.insert(modelItem)
        try context.save() // Apply the context to the DB.
    }
    
    func delete(_ item: Schedule) throws {
        // If there are ever any Sendable errors we can just take the item's ID as a parameter
        // and remove that item by fetching the related item.
        // try! context.fetch(FetchDescriptor<Schedule>(predicate: #Predicate { $0.id == itemID }))
        modelContext.delete(item)
        try modelContext.save()
    }
    
    func fetch() throws -> [Schedule] {
        try modelContext.fetch(FetchDescriptor<Schedule>())
    }
    
    func fetch(descriptor: FetchDescriptor<Schedule>) throws -> [Schedule] {
        try modelContext.fetch(descriptor)
    }
    
    func updateFields(of item: inout Schedule, using updates: (Schedule) -> Void) throws {
        guard let fetchedItem = modelContext.model(for: item.id) as? Schedule else {
            throw DataSourceError.notFound
        }
        
        updates(fetchedItem)
        
        try modelContext.save()
        item = fetchedItem
    }
    
    func eraseAllData() throws {
        try modelContext.delete(model: Schedule.self)
    }
}
