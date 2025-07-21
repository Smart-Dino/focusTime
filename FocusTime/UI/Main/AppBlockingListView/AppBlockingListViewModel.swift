//
//  AppBlockingListViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import Foundation
import SwiftData
import FamilyControls

@MainActor
@Observable
final class AppBlockingListViewModel {
    struct State {
        var page = 0
        var items = [ProtectedBlockItem]()
    }
    
    private(set) var state: State
    private let blockItemStore: BlockItemStore
    
    var fetchTask: Task<Void, Never>?
    
    init(
        state: State = State(),
        modelContainer: ModelContainer
    ) {
        self.state = state
        self.blockItemStore = BlockItemStore(modelContainer: modelContainer)
    }
    
    func insertTestItemsIntoDatabase() async throws {
        Task.detached(priority: .userInitiated) {
            let itemsToInsert = Array(
                repeating: ProtectedBlockItem(emoji: "😜", name: "Block", blockedContent: FamilyActivitySelection()),
                count: 100
            )
            try await self.blockItemStore.insertBatch(itemsToInsert)

            await self.fetchNextPage()
        }
    }
    
    private func fetchNextPage() {
        guard fetchTask == nil else { return }
        
        self.fetchTask = Task.detached(priority: .userInitiated) {
            let insertedItems = try? await self.blockItemStore.fetch(page: self.state.page)
            await MainActor.run {
                self.state.items.append(contentsOf: insertedItems ?? [])
                self.state.page += 1
                self.fetchTask = nil
                print("Items on screen: \(self.state.items.count)")
            }
        }
    }
    
    func hasReachEndOfList(blockItem: ProtectedBlockItem){
        if blockItem.id == state.items.last?.id {
            fetchNextPage()
        }
    }
}
