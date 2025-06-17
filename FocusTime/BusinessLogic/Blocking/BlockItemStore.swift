//
//  BlockItemStore.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftData
import Foundation

@MainActor
final class BlockItemStore: DataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    init() {
        let container = try! ModelContainer(
            for: BlockItem.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: ProcessInfo.isOnPreview() ? true : false)
        )
        let context = container.mainContext
        self.modelContainer = container
        self.modelContext = context
    }
    
    func insert(_ item: BlockItem) throws {
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
        guard var fetchedItem = modelContext.model(for: item.id) as? BlockItem else {
            throw DataSourceError.notFound
        }
        
        updates(fetchedItem)
        
        try modelContext.save()
        item = fetchedItem
    }
}
