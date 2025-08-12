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
    
    func subscribeToDB() {
        print(String(describing: self) + " " + ObjectIdentifier(self).debugDescription)
        dbChangesNotificationTask = Task {
            for await _ in await blockItemPersistenceManager.contextChangesStream() {
                loadData()
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
            fetchNextPage()
        } else {
            reloadItems()
        }
    }
    
    private func reloadItems() {
        fetchTask = nil
        
        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.reloadPaginatedData(
                    totalCount: state.items.count,
                    packSize: state.amountPerPage,
                    includeTemporary: false
                )
                state.items = newItems
            } catch {
                state.error = error
            }
        }
    }
    
    func makeTimerViewModelForActiveSession(blockItem: ProtectedBlockItem, timeLeft: Int) -> FocusSessionTimerModel {
        let isPaused: Bool = {
            if case .duration(_, _, let suspendedAt, _) = blockItem.type {
                return suspendedAt != nil
            }
            return false
        }()

        let deadline = Date.now.addingTimeInterval(TimeInterval(timeLeft))
        return FocusSessionTimerModel(
            state: .init(isPaused: isPaused),
            deadline: deadline,
            delegate: nil
        )
    }
    
    #warning("Unfinished ViewModel")
    private func fetchNextPage() {
        fetchTask = nil
        
        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.fetchPaginated(
                    page: state.page,
                    amountPerPage: state.amountPerPage,
                    includeTemporary: false
                )
                state.items.append(contentsOf: newItems)
                state.page += 1
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
