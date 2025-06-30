//
//  BlockItemStore.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftData
import Foundation
import FamilyControls

@MainActor
final class BlockItemStore: DataSource {
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
    
    @GlobalSourceActor func insert(_ item: ProtectedBlockItem) throws { // Implicitly async since runs in a different context.
        let container = modelContainer
        let context = ModelContext(container) // Create a separate, non-main context to write to.
        let modelItem = BlockItem(from: item) // Convert to model instance.
        context.insert(modelItem)
        try context.save() // Apply the context to the DB.
    }
    
    func delete(_ item: BlockItem) throws {
        // If there are ever any Sendable errors we can just take the item's ID as a parameter
        // and remove that item by fetching the related item.
        // try! context.fetch(FetchDescriptor<BlockItem>(predicate: #Predicate { $0.id == itemID }))
        modelContext.delete(item)
        try modelContext.save()
    }
    
    func fetch() throws -> [BlockItem] {
        try modelContext.fetch(FetchDescriptor<BlockItem>())
    }
    
    func fetch(descriptor: FetchDescriptor<BlockItem>) throws -> [BlockItem] {
        try modelContext.fetch(descriptor)
    }
    
    func updateFields(of item: inout BlockItem, using updates: (BlockItem) -> Void) throws {
        guard let fetchedItem = modelContext.model(for: item.id) as? BlockItem else {
            throw DataSourceError.notFound
        }
        
        updates(fetchedItem)
        
        try modelContext.save()
        item = fetchedItem
    }
    
    func eraseAllData() throws {
        try modelContext.delete(model: BlockItem.self)
    }
}
