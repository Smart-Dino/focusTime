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
    
    #warning("Unfinished ViewModel")
    private func fetchNextPage() {
        guard fetchTask == nil else { return }
        
        self.fetchTask = Task.detached(priority: .userInitiated) {
            do {
                let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
                
                let insertedItems = try await blockItemStore.fetch(page: self.state.page)
                let filteredItems = insertedItems.filter { $0.isTemporary == false }
                await MainActor.run {
                    self.state.items.append(contentsOf: filteredItems)
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
