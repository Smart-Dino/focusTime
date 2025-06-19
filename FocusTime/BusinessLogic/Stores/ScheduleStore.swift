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
        #warning("Memory only container")
        let container = try! ModelContainer(
            for: BlockItem.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = container.mainContext
        self.modelContainer = container
        self.modelContext = context
    }
    
    @GlobalSourceActor func insert(_ item: Schedule) /*async*/ throws {
        let container = modelContainer
        let context = ModelContext(container)
        context.insert(item)
        if Thread.isMainThread {
            fatalError()
        }
        try context.save()
    }
    
    func delete(_ item: Schedule) throws {
//        try! context.fetch(FetchDescriptor<BlockItem>(predicate: #Predicate { $0.id == itemID }))
        modelContext.delete(item)
        try modelContext.save()
    }
    
    func fetchAll() throws -> [Schedule] {
        try modelContext.fetch(FetchDescriptor<Schedule>())
    }
    
    func updateFields(of item: inout Schedule, using updates: (Schedule) -> Void) throws {
        guard let fetchedItem = modelContext.model(for: item.id) as? Schedule else {
            throw DataSourceError.notFound
        }
        
        updates(fetchedItem)
        
        try modelContext.save()
        item = fetchedItem
    }
}
