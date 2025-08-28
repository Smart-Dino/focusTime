//
//  AppBlockingListViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftData
import Foundation
import FocusTimeUI
import FamilyControls

@MainActor
@Observable
final class DraftsBlockItemListViewModel {
    @MainActor
    struct State {
        let timer: FTTimer // There can only be one schedule running at a time.
        var timerPayload: FTTimerPayload {
            timer.payload
        }
        
        var error: Error? = nil
        
        var page = 0
        let amountPerPage = SharedAppValues.amountOfItemsPerPage
        var items = [ProtectedBlockItem]()
    }
    
    private(set) var state: State
    
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    
    private var fetchTask: Task<Void, Never>?
    private var dbChangesNotificationTask: Task<Void, Never>?
    
    init(
        state: State,
        blockItemPersistenceManager: BlockItemPersistenceManager
    ) {
        self.state = state
        self.blockItemPersistenceManager = blockItemPersistenceManager
    }
    
    private func reloadItems() {
        fetchTask?.cancel()
        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.reloadPaginatedData(
                    totalPages: state.page,
                    packSize: state.amountPerPage
                )
                state.items = newItems
                setupTimerForActiveItem()
            } catch {
                state.error = error
            }
            fetchTask = nil
        }
    }
    
    private func fetchNextPage() {
        guard fetchTask == nil else { return }
        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.fetchPaginated(
                    page: state.page,
                    amountPerPage: state.amountPerPage
                )
                state.items.append(contentsOf: newItems)
                setupTimerForActiveItem()
                if !newItems.isEmpty || !(newItems.count < state.amountPerPage) {
                    state.page += 1
                }
            } catch {
                state.error = error
            }
            fetchTask = nil
        }
    }
    
    func subscribeToDB() {
        dbChangesNotificationTask = Task {
            for await _ in await blockItemPersistenceManager.contextChangesStream() {
                try? await Task.sleep(for: SharedAppValues.debounceAfterDBRefreshed)
                reloadItems()
            }
        }
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func loadData() {
        if state.items.isEmpty {
            state.page = 0
            fetchNextPage()
        } else {
            reloadItems()
        }
    }
    
    private func setupTimerForActiveItem() {
         if let activeItem = state.items.first(where: { $0.state.isActive }) {
             state.timer.startTimer(for: activeItem, withSuspensionCountdown: false)
         }
     }
    
    func hasReachEndOfList(blockItem: ProtectedBlockItem) {
        if blockItem.id == state.items.last?.id {
            fetchNextPage()
        }
    }
}
