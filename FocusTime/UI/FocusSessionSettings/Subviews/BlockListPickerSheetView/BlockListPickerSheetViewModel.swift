//
//  BlockListPickerSheetViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.08.2025.
//

import Foundation

@MainActor
@Observable
final class BlockListPickerSheetViewModel {
    struct State {
        var error: Error? = nil
        
        var page = 0
        let amountPerPage = SharedAppValues.amountOfItemsPerPage
        
        var selectedBlockItems: Set<ProtectedBlockItem> = []
        var blockItems: [ProtectedBlockItem] = []
    }
    
    private(set) var state: State
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    
    private var fetchTask: Task<Void, Never>?
    
    init(
        state: State = State(),
        blockItemPersistenceManager: BlockItemPersistenceManager
    ) {
        self.state = state
        self.blockItemPersistenceManager = blockItemPersistenceManager
    }
    
    func isSelected(_ blockItem: ProtectedBlockItem) -> Bool {
        state.selectedBlockItems.contains(blockItem)
    }
    
    func toggleBlockItem(_ blockItem: ProtectedBlockItem, isSelected: Bool) {
        if state.selectedBlockItems.contains(blockItem) {
            state.selectedBlockItems.remove(blockItem)
        } else {
            state.selectedBlockItems.insert(blockItem)
        }
    }
    
    func fetchNextPage() {
        guard fetchTask == nil else { return }
        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.fetchPaginated(
                    page: state.page,
                    amountPerPage: state.amountPerPage
                )
                state.blockItems.append(contentsOf: newItems)
                state.page += 1
            } catch {
                state.error = error
            }
            fetchTask = nil
        }
    }
    
    func hasReachEndOfList(blockItem: ProtectedBlockItem) {
        if blockItem.id == state.blockItems.last?.id {
            fetchNextPage()
        }
    }
    
}
