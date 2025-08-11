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
actor BlockItemStore: PersistenceStore {
    
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
        let model = try fetchForID(id)
        modelContext.delete(model)
        try modelContext.save()
    }
    
    func fetch() throws -> [ProtectedBlockItem] {
        return try modelContext
            .fetch(FetchDescriptor<BlockItem>())
            .map { ProtectedBlockItem(from: $0) }
    }
    
    func fetch(page: Int = 1, amountPerPage: Int = 50) throws -> [ProtectedBlockItem] {
        let alreadyFetched = page * amountPerPage
        
        var descriptor = FetchDescriptor<BlockItem>()
        descriptor.fetchLimit = amountPerPage
        descriptor.fetchOffset = alreadyFetched
        
        let fetched = try modelContext.fetch(descriptor)
        
        return fetched.map {
            ProtectedBlockItem(from: $0)
        }
    }
    
    func fetch(id: PersistentIdentifier) throws -> ProtectedBlockItem {
        let model = try fetchForID(id)
        
        return ProtectedBlockItem(from: model)
    }
    
    func fetch(descriptor: FetchDescriptor<BlockItem>) throws -> [ProtectedBlockItem] {
        try modelContext.fetch(descriptor).map{ ProtectedBlockItem(from: $0) }
    }
    
    func updateFields(id: PersistentIdentifier, using updates: (BlockItem) -> Void) throws {
        let model = try fetchForID(id)
        
        updates(model)
        
        try modelContext.save()
    }
    
    func eraseAllData() throws {
        try modelContext.delete(model: BlockItem.self)
    }
}

// MARK: Helpers
extension BlockItemStore {
    func fetchForID(_ id: PersistentIdentifier) throws -> BlockItem {
        let descriptor = FetchDescriptor<BlockItem>(
            predicate: #Predicate { $0.persistentModelID == id }
        )
        
        let results = try modelContext.fetch(descriptor)
        guard let model = results.first else {
            throw PersistenceStoreError.notFound
        }
        
        return model
    }
}
