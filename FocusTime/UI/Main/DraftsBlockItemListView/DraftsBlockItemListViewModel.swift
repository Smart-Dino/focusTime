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
    struct State {
        var error: Error? = nil
        
        var page = 0
        let amountPerPage = 100
        var items = [ProtectedBlockItem]()
    }
    
    private(set) var state: State
    
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    private var currentTimerViewModel: FocusSessionTimerModel? = nil
    
    private var fetchTask: Task<Void, Never>?
    private var dbChangesNotificationTask: Task<Void, Never>?
    
    init(
        state: State = State(),
        blockItemPersistenceManager: BlockItemPersistenceManager
    ) {
        self.state = state
        self.blockItemPersistenceManager = blockItemPersistenceManager
        
        subscribeToDB()
    }
    
    func makeTimerViewModel(for blockItem: ProtectedBlockItem, timeLeft: Int) -> FocusSessionTimerModel {
        if let currentTimerViewModel {
            return currentTimerViewModel
        }
        
        let isPaused = {
            if case .duration(_, _, let suspendedAt, _) = blockItem.type {
                return suspendedAt != nil
            }
            return false
        }()
        
        currentTimerViewModel = FocusSessionTimerModel(
            state: .init(isPaused: isPaused),
            deadline: .now.addingTimeInterval(TimeInterval(timeLeft)),
            delegate: self
        )

        return currentTimerViewModel!
    }
    
    private func reloadItems() {
        fetchTask?.cancel()
        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.reloadPaginatedData(
                    totalCount: state.items.count,
                    packSize: state.amountPerPage
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
                    amountPerPage: state.amountPerPage
                )
                state.items.append(contentsOf: newItems)
                state.page += 1
            } catch {
                state.error = error
            }
            fetchTask = nil
        }
    }
    
    func subscribeToDB() {
        dbChangesNotificationTask = Task {
            for await _ in await blockItemPersistenceManager.contextChangesStream() {
                try? await Task.sleep(nanoseconds: 200_000_000) // debounce 0.2s
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
    
    func hasReachEndOfList(blockItem: ProtectedBlockItem){
        if blockItem.id == state.items.last?.id {
            fetchNextPage()
        }
    }
}

extension DraftsBlockItemListViewModel: FocusSessionTimerModelDelegate {
    func didUpdateIsPaused(_: Bool) {
        return // Cannot pause from this view.
    }
    
    func didFinishCountdown() {
        currentTimerViewModel = nil
    }
}
