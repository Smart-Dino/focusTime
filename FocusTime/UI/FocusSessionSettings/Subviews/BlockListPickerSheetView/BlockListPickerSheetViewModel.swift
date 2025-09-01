//
//  BlockListPickerSheetViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.08.2025.
//

import Foundation
import FamilyControls

// MARK: - BlockListPickerSheetDelegate
@MainActor
protocol BlockListPickerSheetDelegate: AnyObject {
    func didFinishSelectionWith(_ selection: FamilyActivitySelection)
}

// MARK: - BlockListPickerSheetViewModel
@MainActor
@Observable
final class BlockListPickerSheetViewModel {
    
    // MARK: - State
    struct State {
        // MARK: View State
        var error: Error?
        var shouldDismiss = false
        var isFamilyActivitySheetPresented = false
        var editedItem: ProtectedBlockItem?

        // MARK: Data & Selection
        var finalSelection = FamilyActivitySelection()
        var selectedBlockItems: Set<ProtectedBlockItem> = []
        var blockItems: [ProtectedBlockItem] = []
        
        // MARK: Pagination
        var page = 0
        let amountPerPage = SharedAppValues.amountOfItemsPerPage
    }
    
    // MARK: - Properties
    private(set) var state: State
    weak var delegate: BlockListPickerSheetDelegate?
    
    // MARK: Dependencies
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    
    // MARK: Private State
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Initializer
    init(
        state: State = State(),
        deviceActivityRegistrar: DeviceActivityRegistrar,
        blockItemPersistenceManager: BlockItemPersistenceManager
    ) {
        self.state = state
        self.deviceActivityRegistrar = deviceActivityRegistrar
        self.blockItemPersistenceManager = blockItemPersistenceManager
    }
    
    // MARK: - Public Intents
    
    // MARK: State & Sheet Management
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func setEditingItemSelectionVisibility(_ isVisible: Bool) {
        if !isVisible {
            Task {
                do {
                    guard let editedItem = state.editedItem else { return }
                    state.editedItem = nil
                    
                    try await blockItemPersistenceManager.editBlockItem(blockItem: editedItem)
                    reloadItems()
                } catch {
                    state.error = error
                }
            }
        }
    }
    
    func setIsFamilyActivitySheetPresented(_ isPresented: Bool) {
        state.isFamilyActivitySheetPresented = isPresented
    }

    func dismiss() {
        state.shouldDismiss = true
    }

    // MARK: Selection
    func setEditedItem(_ item: ProtectedBlockItem) {
        state.editedItem = item
    }
    
    func setFamilyActivitySelection(_ selection: FamilyActivitySelection) {
        state.finalSelection = selection
    }
    
    func setFamilyActivityItemSelection(_ selection: FamilyActivitySelection) {
        state.editedItem?.blockedContent = selection
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
    
    func saveSelection() {
        delegate?.didFinishSelectionWith(state.finalSelection)
        dismiss()
    }
    
    // MARK: Data Fetching
    func fetchNextPage() {
        guard fetchTask == nil else { return }

        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.fetchPaginated(
                    page: state.page,
                    amountPerPage: state.amountPerPage
                )

                let existingIDs = Set(state.blockItems.map(\.id))
                let uniqueNewItems = newItems.filter { !existingIDs.contains($0.id) }
                state.blockItems.append(contentsOf: uniqueNewItems)
                
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
    
    func hasReachEndOfList(blockItem: ProtectedBlockItem) {
        if blockItem.id == state.blockItems.last?.id {
            fetchNextPage()
        }
    }
    
    // MARK: - Private Helpers
    private func recomputeFinalSelection() {
        var combined = FamilyActivitySelection()
        
        for item in state.selectedBlockItems {
            combined = combined.merged(with: item.blockedContent)
        }
        
        state.finalSelection = combined
    }
    
    private func reloadItems() {
        fetchTask?.cancel()
        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.reloadPaginatedData(
                    totalPages: state.page,
                    packSize: state.amountPerPage
                )
                state.blockItems = newItems
            } catch {
                state.error = error
            }
            fetchTask = nil
        }
    }

    private func openFamilyActivitySelectionIfNeeded() {
        if state.blockItems.isEmpty && state.page <= 1 {
            setIsFamilyActivitySheetPresented(true)
        }
    }
}
