//
//  BlockItemStore.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftData
import Foundation
import FamilyControls

@ModelActor
actor BlockItemStore: DataSource { 
    
    func insert(_ item: ProtectedBlockItem) throws { // Implicitly async since runs in a different context.
        let container = modelContainer
        let context = ModelContext(container) // Create a separate, non-main context to write to.
        let modelItem = BlockItem(from: item) // Convert to model instance.
        context.insert(modelItem)
        try context.save() // Apply the context to the DB.
    }
    
    func delete(id: PersistentIdentifier) throws {
        // If there are ever any Sendable errors we can just take the item's ID as a parameter
        // and remove that item by fetching the related item.
        // try! context.fetch(FetchDescriptor<BlockItem>(predicate: #Predicate { $0.id == itemID }))
        guard let item = try fetch(id: id) else { throw DataSourceError.notFound }
        modelContext.delete(item)
        try modelContext.save()
    }
    
    func fetch() throws -> [BlockItem] {
        try modelContext.fetch(FetchDescriptor<BlockItem>())
    }
    
    func fetch(id: PersistentIdentifier) throws -> BlockItem? {
        modelContext.model(for: id) as? BlockItem
    }
    
    func fetch(descriptor: FetchDescriptor<BlockItem>) throws -> [BlockItem] {
        try modelContext.fetch(descriptor)
    }
    
    func updateFields(id: PersistentIdentifier, using updates: (BlockItem) -> Void) throws {
        guard let fetchedItem = modelContext.model(for: id) as? BlockItem else {
            throw DataSourceError.notFound
        }
        
        updates(fetchedItem)
        
        try modelContext.save()
    }
    
    func eraseAllData() throws {
        try modelContext.delete(model: BlockItem.self)
    }
}
