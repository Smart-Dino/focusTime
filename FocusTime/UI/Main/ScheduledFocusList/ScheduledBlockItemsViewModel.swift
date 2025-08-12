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

    private func reloadItems() {
        fetchTask?.cancel()
        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.reloadPaginatedData(
                    totalCount: state.items.count,
                    packSize: state.amountPerPage,
                    scheduledOnly: true
                )
                state.items = newItems
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
                    amountPerPage: state.amountPerPage,
                    scheduledOnly: true
                )
                state.items.append(contentsOf: newItems)
                state.page += 1
            } catch {
                state.error = error
            }
            fetchTask = nil
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

    func hasReachEndOfList(blockItem: ProtectedBlockItem){
        if blockItem.id == state.items.last?.id {
            fetchNextPage()
        }
    }
}
