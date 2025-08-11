//
//  LiveBlockItemPersistenceManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 08.08.2025.
//

import SwiftData
import Foundation

actor LiveBlockItemPersistenceManager: BlockItemPersistenceManager, Sendable {
    private var store: BlockItemStore

    private(set) var continuation: AsyncStream<Bool>.Continuation?
    
    init(blockItemStore: BlockItemStore) {
        self.store = blockItemStore
        
        Task {
            for await _ in NotificationCenter.default.notifications(named: .NSPersistentStoreRemoteChange) {
                print("UPDATEEEEEE!!!!")
            }
        }
    }
    
    // MARK: If any ViewModel needs specific values of methods add them here instead of that ViewModel.
    
    func insert(_ item: ProtectedBlockItem) async throws {
        try await store.insert(item)
    }
    
    func insert(_ item: inout ProtectedBlockItem) async throws {
        let persistenceID = try await store.insert(item)
        let itemCopy = ProtectedBlockItem(
            id: item.id,
            persistentModelID: persistenceID,
            emoji: item.emoji,
            name: item.name,
            days: item.days,
            type: item.type,
            blockedContent: item.blockedContent
        )
        item = itemCopy
    }
    
    /// Applies passed ``ProtectedBlockItem`` to it's corresponding model.
    func editBlockItem(blockItem: ProtectedBlockItem) async throws {
        guard let id = blockItem.persistentModelID else { return }
        try await store.updateFields(id: id) { model in
            model.emoji = blockItem.emoji
            model.name = blockItem.name
            model.days = blockItem.days
            model.type = blockItem.type
            model.blockedContent = blockItem.blockedContent
        }
    }
    
    func fetch(by uuid: UUID) async throws -> ProtectedBlockItem? {
        let predicate = #Predicate<BlockItem> { $0.id == uuid }
        let descriptor = FetchDescriptor<BlockItem>(predicate: predicate)
        let items = try await store.fetch(descriptor: descriptor)
        
        if let item = items.first {
            return item
        } else {
            return nil
        }
    }
    
    func fetch(by persistenceIdentifier: PersistentIdentifier) async throws -> ProtectedBlockItem {
        try await store.fetch(id: persistenceIdentifier)
    }
    
    func fetch(includeTemporary: Bool) async throws -> [ProtectedBlockItem] {
        let items = try await store.fetch()
        
        if includeTemporary {
            return items
        } else {
            return items.filter { !$0.isTemporary }
        }
    }
    
    func fetchPaginated(
        page: Int,
        amountPerPage: Int,
        includeTemporary: Bool
    ) async throws -> [ProtectedBlockItem] {
        let items = try await store.fetch(page: page, amountPerPage: page)
        
        if includeTemporary {
            return items
        } else {
            return items.filter { !$0.isTemporary }
        }
    }
    
    /// Loads `ProtectedBlockItem`s in packs of `packSize` asynchronously
    /// and updates the given array in-place one pack at a time.
    /// - Parameters:
    ///   - items: The existing list to update in place (must already have `count` slots).
    ///   - packSize: Number of items to fetch per batch.
    ///   - includeTemporary: If `false`, filters out temporary items.
    func reloadPaginatedData(
        items: inout [ProtectedBlockItem],
        packSize: Int,
        includeTemporary: Bool
    ) async throws {
        // Total number of items to process (based on the initial array length).
        let totalCount = items.count

        // Loop over offsets in steps of `packSize`.
        // Example: totalCount=10, packSize=3 → offsets: 0, 3, 6, 9
        for offset in stride(from: 0, to: totalCount, by: packSize) {
            
            // Build a predicate to include/exclude temporary items.
            let predicate = #Predicate<BlockItem> { model in
                includeTemporary || !model.isTemporary
            }

            // Configure fetch descriptor for the current page.
            var descriptor = FetchDescriptor<BlockItem>(predicate: predicate)
            descriptor.fetchLimit = min(packSize, totalCount - offset) // Don't overrun the end.
            descriptor.fetchOffset = offset // Start position for this page.

            // Perform the async fetch from the data store.
            let fetchedBlockItems = try await store.fetch(descriptor: descriptor)

            // Replace the corresponding slice of the existing `items` array
            // with the newly fetched protected items.
            items.replaceSubrange(
                offset..<offset + fetchedBlockItems.count,
                with: fetchedBlockItems
            )

            // Optional: yield back to the executor so SwiftUI can refresh UI
            // between batches (especially useful for large lists).
            await Task.yield()
        }
    }
    
    func eraseAllData() async throws {
        try await store.eraseAllData()
    }
    
    // MARK: - AsyncStream
    func contextChangesStream() -> AsyncStream<Bool> {
        let stream = AsyncStream<Bool> { continuation in
            self.continuation = continuation
        }
        
        self.continuation?.onTermination = { @Sendable reason in
            Task { await self.handleTermination(reason) }
        }
        
        return stream
    }
    
    private func handleTermination(_ reason: AsyncStream<Bool>.Continuation.Termination) {
        // Swift marked the stream as terminated,
        // finishing the continuation.
        continuation?.finish()
        continuation = nil
        
        // switch reason {
        //   case .cancelled:   …
        //   case .finished:    …
        // }
    }
}
