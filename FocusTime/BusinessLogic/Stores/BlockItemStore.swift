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

    init?(isStoredInMemoryOnly: Bool = false) {
        #warning("Memory only container")
        let container = try? ModelContainer(
            for: BlockItem.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        )
        guard let container else { return nil }
        
        let context = container.mainContext
        self.modelContainer = container
        self.modelContext = context
    }
    
    @GlobalStoreActor func insert(_ item: BlockItem) throws { // Implicitly async since runs in a different context
        let container = modelContainer
        let context = ModelContext(container) // Create a separate, non-main context to write to
        context.insert(item)
        try context.save() // Apply the context to the DB
    }
    
    func delete(_ item: BlockItem) throws {
        // If there are ever any Sendable errors we can just take the item's ID as a parameter
        // and remove that item by fetching the related item.
        // try! context.fetch(FetchDescriptor<BlockItem>(predicate: #Predicate { $0.id == itemID }))
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
