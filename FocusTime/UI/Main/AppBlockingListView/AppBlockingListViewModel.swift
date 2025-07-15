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
    private let modelContainer: ModelContainer
    
    var fetchTask: Task<Void, Never>?
    
    init(state: State = State(), modelContainer: ModelContainer) {
        self.state = state
        self.modelContainer = modelContainer
    }
    
    func insertTestItemsIntoDatabase() async throws {
        Task.detached(priority: .userInitiated) {
            let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
            let itemsToInsert = Array(
                repeating: ProtectedBlockItem(emoji: "😜",
                                              name: "Block",
                                              blockedContent: ProtectedActivitySelection(.init())),
                count: 100000
            )
            try await blockItemStore.insertBatch(itemsToInsert)
//            let insertedItems = try? await blockItemStore.fetch()
//            await MainActor.run {
//                self.state.items = insertedItems ?? []
//            }
            await self.fetchNextPage()
        }
    }
    
    private func fetchNextPage() {
        guard fetchTask == nil else { return }
        
        self.fetchTask = Task.detached(priority: .userInitiated) {
            let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
            let insertedItems = try? await blockItemStore.fetch(page: self.state.page)
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
