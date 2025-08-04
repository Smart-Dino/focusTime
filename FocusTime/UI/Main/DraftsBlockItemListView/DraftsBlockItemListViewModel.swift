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
final class DraftsBlockItemListViewModel {
    struct State {
        var error: Error? = nil
        
        var page = 0
        var items = [ProtectedBlockItem]()
    }
    
    private(set) var state: State
    private let blockItemStore: BlockItemStore
    
    private var fetchTask: Task<Void, Never>?
    
    init(
        state: State = State(),
        modelContainer: ModelContainer
    ) {
        self.state = state
        self.blockItemStore = BlockItemStore(modelContainer: modelContainer)
    }
    
    func keepShowingError(showError: Bool) {
        if !showError {
            state.error = nil
        }
    }
    
    #warning("Unfinished ViewModel")
    func insertTestItemsIntoDatabase() async {
        Task.detached(priority: .userInitiated) {
            do {
                let itemsToInsert = (0..<100).map { number in
                    ProtectedBlockItem(
                        emoji: "😜",
                        name: "Block - \(number)",
                        days: [.saturday, .sunday],
                        type: .scheduled(startTime: TimeComponents(hour: 17, minute: 00)!,
                                         endTime: TimeComponents(hour: 19, minute: 00)!),
                        blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
                    )
                }
                try await self.blockItemStore.insertBatch(itemsToInsert)
                
                await self.fetchNextPage()
            } catch {
                await MainActor.run {
                    self.state.error = error
                }
            }
        }
    }
    
    private func fetchNextPage() {
        guard fetchTask == nil else { return }
        
        self.fetchTask = Task.detached(priority: .userInitiated) {
            do {
                let insertedItems = try await self.blockItemStore.fetch(page: self.state.page)
                await MainActor.run {
                    self.state.items.append(contentsOf: insertedItems)
                    self.state.page += 1
                    self.state.error = nil
                    self.fetchTask = nil
                    print("Items on screen: \(self.state.items.count)")
                }
            } catch {
                await MainActor.run {
                    self.state.error = error
                    self.fetchTask = nil
                    print("Failed to fetch page \(self.state.page): \(error)")
                }
            }
        }
    }
    
    func hasReachEndOfList(blockItem: ProtectedBlockItem){
        if blockItem.id == state.items.last?.id {
            fetchNextPage()
        }
    }
}
