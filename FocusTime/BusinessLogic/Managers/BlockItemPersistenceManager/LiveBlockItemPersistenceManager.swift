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
        continuation?.finish()
        continuation = nil
        databaseChanges?.cancel()
        databaseChanges = nil
    }
    
    func listenToDatabaseFileChanges() {
        databaseChanges = Task.detached { [weak self] in
            for await _ in NotificationCenter.default.notifications(named: .NSPersistentStoreRemoteChange) {
                await self?.continuation?.yield(true)
            }
        }
    }
    
    // MARK: If any ViewModel needs specific values of methods add them here instead of that ViewModel.
    
    func insert(_ item: ProtectedBlockItem) async throws {
        var item = item
        item.name = item.name.collapsedLines()
        
        try await store.insert(item)
    }
    
    func insert(_ item: inout ProtectedBlockItem) async throws {
        item.name = item.name.collapsedLines()
        
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
    
    func delete(blockItem: ProtectedBlockItem) async throws {
        guard let id = blockItem.persistentModelID else {
            throw PersistenceStoreError.noIdentifier
        }
        
        try await store.delete(id: id)
    }
    
    /// Applies passed ``ProtectedBlockItem`` to it's corresponding model.
    func editBlockItem(blockItem: ProtectedBlockItem) async throws {
        guard let id = blockItem.persistentModelID else { return }
        try await store.updateFields(id: id) { model in
            model.emoji = blockItem.emoji
            model.name = blockItem.name.collapsedLines()
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
        // 1. Fetch all blocks.
        let blocks = try await store.fetch().filter { !$0.isTemporary }

        // 2. Prioritize and return a running block if one exists.
        if let running = blocks.first(where: { $0.state.isActive }) {
            return running
        }

        // 3. Filter for only valid, schedulable blocks.
        // This removes temporary, cancelled, or non-scheduled items immediately.
        let scheduledBlocks = await markScheduled(blocks).filter {
            $0.isScheduled && !$0.isCancelled
        }

        // 4. For each block, calculate its next concrete occurrence date after `now`.
        let upcomingOccurrences = scheduledBlocks.compactMap { block -> (item: ProtectedBlockItem, nextFireDate: Date)? in
            guard let nextDate = findNextOccurrence(for: block, after: now) else {
                return nil
            }
            return (item: block, nextFireDate: nextDate)
        }

        // 5. Find the occurrence that happens soonest.
        let closestUpcoming = upcomingOccurrences.min {
            $0.nextFireDate < $1.nextFireDate
        }

        // 6. Return the block associated with that closest occurrence.
        // If no upcoming blocks are found, this will correctly return nil.
        return closestUpcoming?.item
    }
    
    func fetchPaginated(
        page: Int,
        amountPerPage: Int
    ) async throws -> [ProtectedBlockItem] {
        let items = try await store.fetch(page: page, amountPerPage: amountPerPage)
        let filteredFromTemp = items.filter { !$0.isTemporary }
        
        return await markScheduled(filteredFromTemp)
    }
    
    func reloadPaginatedData(
        totalPages: Int,
        packSize: Int
    ) async throws -> [ProtectedBlockItem] {
        var allItems: [ProtectedBlockItem] = []

        for page in 0...totalPages {
            let predicate = #Predicate<BlockItem> { model in
                !model.isTemporary
            }

            var descriptor = FetchDescriptor<BlockItem>(predicate: predicate)
            descriptor.fetchOffset = page * packSize
            descriptor.fetchLimit = packSize

            let fetchedBlockItems = try await store.fetch(descriptor: descriptor)
            allItems.append(contentsOf: fetchedBlockItems)

            await Task.yield()
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
        continuation?.finish()
        continuation = nil
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
    
    /// A helper function to find the next valid occurrence of a block after a given date.
    /// - Parameters:
    ///   - block: The block item with its schedule days (`.days`) and start time (`.type`).
    ///   - date: The date to search after (typically `Date()`).
    /// - Returns: A concrete `Date` for the next scheduled run, or `nil` if none can be found.
    /// - Note: Uses the user’s current calendar and time zone. If the user changes time zones,
    ///         the computed next occurrence will shift accordingly.
    private func findNextOccurrence(for block: ProtectedBlockItem, after date: Date) -> Date? {
        // Ensure the block is a scheduled type and has days assigned.
        guard case .scheduled(let startTime, _, _, _, _) = block.type, !block.days.isEmpty else {
            return nil
        }

        // Explicitly tie to current time zone to avoid surprises.
        var calendar = Calendar.current
        calendar.timeZone = .current

        // Look at today + the next 6 days (1 full week).
        for dayOffset in 0..<7 {
            guard let searchDate = calendar.date(byAdding: .day, value: dayOffset, to: date) else {
                continue
            }

            let weekdayComponent = calendar.component(.weekday, from: searchDate)
            guard let weekday = Weekday(rawValue: weekdayComponent), block.days.contains(weekday) else {
                continue // Not a valid scheduled weekday for this block.
            }

            // Construct full candidate date with correct year/month/day + time-of-day.
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: searchDate)
            let time = startTime.dateComponents
            dateComponents.hour = time.hour
            dateComponents.minute = time.minute

            if let candidate = calendar.date(from: dateComponents), candidate > date {
                return candidate // Short-circuit: return first valid match.
            }
        }

        return nil
    }
}
