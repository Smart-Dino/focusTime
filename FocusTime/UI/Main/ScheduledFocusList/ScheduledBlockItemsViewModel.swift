//
//  ScheduledBlockItemsViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import SwiftData
import Foundation
import FamilyControls

@MainActor
@Observable
final class ScheduledBlockItemsViewModel {
    struct State {
        var error: Error? = nil
        var page = 0
        var items = [ProtectedBlockItem]()
    }
    
    private(set) var state: State
    private let modelContainer: ModelContainer
    
    private var fetchTask: Task<Void, Never>?
    
    init(
        state: State = State(),
        modelContainer: ModelContainer
    ) {
        self.state = state
        self.modelContainer = modelContainer
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
                let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
                
                let startTime = try TimeComponents(hour: 17, minute: 00)
                let endTime = try TimeComponents(hour: 19, minute: 00)
                let itemsToInsert = (0..<100).map { number in
                    ProtectedBlockItem(
                        emoji: "😜",
                        name: "Block - \(number)",
                        days: [.saturday, .sunday],
                        type: .scheduled(startTime: startTime,
                                         endTime: endTime),
                        blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
                    )
                }
                try await blockItemStore.insertBatch(itemsToInsert)
                
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
                let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
                
                let insertedItems = try await blockItemStore.fetch(page: self.state.page)
                await MainActor.run {
                    self.state.items.append(contentsOf: insertedItems)
                    self.state.page += 1
                    self.state.error = nil
                    self.fetchTask = nil
                }
            } catch {
                await MainActor.run {
                    self.state.error = error
                    self.fetchTask = nil
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
