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
        let amountPerPage = 100
        var items = [ProtectedBlockItem]()
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
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    #warning("Unfinished ViewModel")
    private func fetchNextPage() {
        guard fetchTask == nil else { return }
        
        self.fetchTask = Task {
            do {
                state.items = try await blockItemPersistenceManager.fetchPaginated(
                    page: state.page,
                    amountPerPage: state.amountPerPage,
                    includeTemporary: false
                )
            } catch {
                state.error = error
            }
        }
    }
    
    func hasReachEndOfList(blockItem: ProtectedBlockItem){
        if blockItem.id == state.items.last?.id {
            fetchNextPage()
        }
    }
}
