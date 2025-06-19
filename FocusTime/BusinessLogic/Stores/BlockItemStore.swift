//
//  BlockItemStore.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftData
import Foundation
import FamilyControls

@globalActor
actor GlobalSourceActor {
    static let shared = GlobalSourceActor()
}

@ModelActor
actor BlockItemStore1: DataSource1 {
    func insert(_ item: BlockItem) throws {
        print(Thread.current)
        modelContext.insert(item)
        try modelContext.save()
    }
    
    func delete(_ item: BlockItem) throws {
        modelContext.delete(item)
        try modelContext.save()
    }
    
    func fetchAll() throws -> [BlockItem] {
        try modelContext.fetch(FetchDescriptor<BlockItem>())
    }
    
    func updateFields(of item: inout BlockItem, using updates: (BlockItem) -> Void) throws {
        guard let fetchedItem = modelContext.model(for: item.id) as? BlockItem else {
            throw DataSourceError.notFound
        }
        
        updates(fetchedItem)
        
        try modelContext.save()
        item = fetchedItem
    }
}

@MainActor
final class BlockItemStore: DataSource {
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
    
    @GlobalSourceActor func insert(_ item: BlockItem) /*async*/ throws {
        let container = modelContainer
        let context = ModelContext(container)
        context.insert(item)
        if Thread.isMainThread {
            fatalError()
        }
        try context.save()
    }
    
    func delete(_ item: BlockItem) throws {
//        try! context.fetch(FetchDescriptor<BlockItem>(predicate: #Predicate { $0.id == itemID }))
        modelContext.delete(item)
        try modelContext.save()
    }
    
    func fetchAll() throws -> [BlockItem] {
        try modelContext.fetch(FetchDescriptor<BlockItem>())
    }
    
    func updateFields(of item: inout BlockItem, using updates: (BlockItem) -> Void) throws {
        guard let fetchedItem = modelContext.model(for: item.id) as? BlockItem else {
            throw DataSourceError.notFound
        }
        
        updates(fetchedItem)
        
        try modelContext.save()
        item = fetchedItem
    }
}
