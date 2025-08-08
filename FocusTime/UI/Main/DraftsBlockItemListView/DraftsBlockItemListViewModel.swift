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
    
    func reloadData() {
        state.items = .init()
        state.page = 0
        fetchNextPage()
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
