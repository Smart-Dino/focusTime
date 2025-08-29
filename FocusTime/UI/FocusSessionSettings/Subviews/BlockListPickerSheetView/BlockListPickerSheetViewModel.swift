//
//  BlockListPickerSheetViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.08.2025.
//

import Foundation
import FamilyControls

@MainActor
protocol BlockListPickerSheetDelegate: AnyObject {
    func didFinishSelectionWith(_ selection: FamilyActivitySelection)
}

@MainActor
@Observable
final class BlockListPickerSheetViewModel {
    struct State {
        var error: Error? = nil
        
        var finalSelection: FamilyActivitySelection = FamilyActivitySelection()
        var isFamilyActivitySheetPresented: Bool = false
        
        var page = 0
        let amountPerPage = SharedAppValues.amountOfItemsPerPage
        
        var selectedBlockItems: Set<ProtectedBlockItem> = []
        var blockItems: [ProtectedBlockItem] = []
    }
    
    private(set) var state: State
    
    weak var delegate: BlockListPickerSheetDelegate?
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
    
    func setIsFamilyActivitySheetPresented(_ isPresented: Bool) {
        state.isFamilyActivitySheetPresented = isPresented
    }
    
    func setFamilyActivitySelection(_ selection: FamilyActivitySelection) {
        state.finalSelection = selection
    }
    
    func isSelected(_ blockItem: ProtectedBlockItem) -> Bool {
        state.selectedBlockItems.contains(blockItem)
    }
    
    func toggleBlockItem(_ blockItem: ProtectedBlockItem, isSelected: Bool) {
        if isSelected {
            state.selectedBlockItems.insert(blockItem)
        } else {
            state.selectedBlockItems.remove(blockItem)
        }
        recomputeFinalSelection()
    }
    
    private func recomputeFinalSelection() {
        var combined = FamilyActivitySelection()
        
        for item in state.selectedBlockItems {
            combined = combined.merged(with: item.blockedContent)
        }
        
        state.finalSelection = combined
    }
    
    func fetchNextPage() {
        guard fetchTask == nil else { return }

        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.fetchPaginated(
                    page: state.page,
                    amountPerPage: state.amountPerPage
                )

                let existingIDs = Set(state.blockItems.map(\.id))
                state.blockItems.append(contentsOf: newItems.filter { !existingIDs.contains($0.id) })
                
                if !(newItems.count < state.amountPerPage) {
                    state.page += 1
                }
                
            } catch {
                state.error = error
            }
            
            fetchTask = nil
            openFamilyActivitySelectionIfNeeded()
        }
    }
    
    func saveSelection() {
        delegate?.didFinishSelectionWith(state.finalSelection)
    }
    
    func hasReachEndOfList(blockItem: ProtectedBlockItem) {
        if blockItem.id == state.blockItems.last?.id {
            fetchNextPage()
        }
    }
    
    private func openFamilyActivitySelectionIfNeeded() {
        if state.blockItems.isEmpty && state.page <= 1 {
            setIsFamilyActivitySheetPresented(true)
        }
    }
}
