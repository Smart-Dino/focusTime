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
    
    @discardableResult
    func insert(_ item: ProtectedBlockItem) throws -> PersistentIdentifier {
        let model = BlockItem(from: item) // Convert to model instance.
        modelContext.insert(model)
        try modelContext.save() // Apply the context to the DB.
        return model.persistentModelID
    }
    
    @discardableResult
    func insertBatch(_ items: [ProtectedBlockItem]) throws -> Set<PersistentIdentifier> {
        var ids = Set<PersistentIdentifier>()
        for item in items {
            let model = BlockItem(from: item)
            modelContext.insert(model)
            ids.insert(model.persistentModelID)
        }
        try modelContext.save()
        return ids
    }
    
    func delete(id: PersistentIdentifier) throws {
        guard let model = modelContext.model(for: id) as? BlockItem else {
            throw DataSourceError.notFound
        }
        modelContext.delete(model)
        try modelContext.save()
    }
    
    func fetch() throws -> [ProtectedBlockItem] {
        try modelContext
            .fetch(FetchDescriptor<BlockItem>())
            .map { ProtectedBlockItem(from: $0) }
    }
    
    func fetch(id: PersistentIdentifier) throws -> ProtectedBlockItem? {
        let descriptor = FetchDescriptor<BlockItem>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let model = try? modelContext.fetch(descriptor).first else {
            throw DataSourceError.notFound
        }
        
        return ProtectedBlockItem(from: model)
    }
    
    func fetch(descriptor: FetchDescriptor<BlockItem>) throws -> [ProtectedBlockItem] {
        try modelContext.fetch(descriptor).map{ ProtectedBlockItem(from: $0) }
    }
    
    func updateFields(id: PersistentIdentifier, using updates: (BlockItem) -> Void) throws {
        let descriptor = FetchDescriptor<BlockItem>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let model = try? modelContext.fetch(descriptor).first else {
            throw DataSourceError.notFound
        }
        
        updates(model)
        
        try modelContext.save()
    }
    
    func eraseAllData() throws {
        try modelContext.delete(model: BlockItem.self)
    }
}
