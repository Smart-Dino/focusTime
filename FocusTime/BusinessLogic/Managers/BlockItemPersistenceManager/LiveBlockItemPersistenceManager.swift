//
//  LiveBlockItemPersistenceManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 08.08.2025.
//

import SwiftData
import Foundation

actor LiveBlockItemPersistenceManager: BlockItemPersistenceManager, Sendable {
    private let store: BlockItemStore
    private let centerManager: DeviceActivityCenterManager

    private(set) var continuation: AsyncStream<Bool>.Continuation?
    private var databaseChanges: Task<Void, Never>? = nil
    
    init(
        blockItemStore: BlockItemStore,
        deviceActivityCenterManager: DeviceActivityCenterManager
    ) {
        self.store = blockItemStore
        self.centerManager = deviceActivityCenterManager
        
        Task {
            await listenToDatabaseFileChanges()
        }
    }
    
    deinit {
        // Continuation.
        continuation?.finish()
        continuation = nil
        // Database-tracking task.
        databaseChanges?.cancel()
        databaseChanges = nil
    }
    
    func listenToDatabaseFileChanges() {
        databaseChanges = Task {
            for await _ in NotificationCenter.default.notifications(named: .NSPersistentStoreRemoteChange) {
                continuation?.yield(true)
            }
        }
    }
    
    // MARK: If any ViewModel needs specific values of methods add them here instead of that ViewModel.
    
    func insert(_ item: ProtectedBlockItem) async throws {
        try await store.insert(item)
    }
    
    func insert(_ item: inout ProtectedBlockItem) async throws {
        let persistenceID = try await store.insert(item)
        
        // I cannot set persistentID since it is a constant so I will create a new instance instead.
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
    
    func fetchClosestOrRunningCurrentScheduled(now: Date) async throws -> ProtectedBlockItem? {
        let identifiers = await centerManager.monitoredIdentifiers

        // 1. Fetch all monitored blocks.
        let blocks = try await store.fetch()
        let runningOrScheduledBlocks = blocks.filter(
            { $0.isActive || identifiers.contains($0.id) }
        )

        // 2. Return running if found.
        if let running = runningOrScheduledBlocks.first(where: { $0.isActive }) {
            return running
        }

        // 3. Mark scheduled & filter only scheduled ones.
        let scheduledBlocks = await markScheduled(blocks).filter(\.isScheduled)

        guard !scheduledBlocks.isEmpty else {
            return nil
        }

        // 4. Sort by start time.
        let sortedByStartTime = scheduledBlocks.sorted {
            guard case .scheduled(let firstStart, _, _, _) = $0.type,
                  case .scheduled(let secondStart, _, _, _) = $1.type else {
                return false
            }
            return firstStart < secondStart
        }

        // 5. Find the closest future schedule.
        let currentTimeComponent = try TimeComponents(from: now)
        if let upcoming = sortedByStartTime.first(where: {
            guard case .scheduled(let start, _, _, _) = $0.type else { return false }
            return start > currentTimeComponent
        }) {
            return upcoming
        }

        // 6. If no future found, wrap to earliest (next day)
        return sortedByStartTime.first!
    }

    
    func fetchPaginated(
        page: Int,
        amountPerPage: Int
    ) async throws -> [ProtectedBlockItem] {
        let items = try await store.fetch(page: page, amountPerPage: page)
        let filteredFromTemp = items.filter { !$0.isTemporary }
        
        return await markScheduled(filteredFromTemp)
    }
    
    func reloadPaginatedData(
        totalCount: Int,
        packSize: Int
    ) async throws -> [ProtectedBlockItem] {
        var allItems: [ProtectedBlockItem] = []

        for offset in stride(from: 0, to: totalCount, by: packSize) {
            let predicate = #Predicate<BlockItem> { model in
                !model.isTemporary
            }

            var descriptor = FetchDescriptor<BlockItem>(predicate: predicate)
            descriptor.fetchLimit = min(packSize, totalCount - offset)
            descriptor.fetchOffset = offset

            let fetchedBlockItems = try await store.fetch(descriptor: descriptor)
            allItems.append(contentsOf: fetchedBlockItems)

            await Task.yield() // Allow thread to breathe between batches.
        }

        return await markScheduled(allItems)
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

// MARK: Helpers
extension LiveBlockItemPersistenceManager {
    func markScheduled(_ items: [ProtectedBlockItem]) async -> [ProtectedBlockItem] {
        let trackedIdentifiers = await centerManager.monitoredIdentifiers
        var items = items
        
        for i in 0..<items.count {
            let item = items[i]
            if trackedIdentifiers.contains(item.id) {
                items[i].isScheduled = true
            }
        }
        
        return items
    }
}
