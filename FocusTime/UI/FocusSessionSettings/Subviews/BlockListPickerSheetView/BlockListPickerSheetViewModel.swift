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

enum BlockListPickerSheetViewModelNavigationRoute: Equatable, Hashable {
    case focusSession(_ viewModel: FocusSessionViewModel)
    
    var id: Self { self }
    
    static func == (lhs: BlockListPickerSheetViewModelNavigationRoute, rhs: BlockListPickerSheetViewModelNavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case let (.focusSession(lVM), .focusSession(rVM)):
            lVM === rVM
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .focusSession(vm):
            hasher.combine(1)
            hasher.combine(ObjectIdentifier(vm))
        }
    }
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
        
        var nextNavigationScreen: DraftsBlockItemListViewNavigationRoute?
    }
    
    private(set) var state: State
    
    weak var delegate: BlockListPickerSheetDelegate?
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    
    private var fetchTask: Task<Void, Never>?
    
    init(
        state: State = State(),
        deviceActivityRegistrar: DeviceActivityRegistrar,
        blockItemPersistenceManager: BlockItemPersistenceManager
    ) {
        self.state = state
        self.deviceActivityRegistrar = deviceActivityRegistrar
        self.blockItemPersistenceManager = blockItemPersistenceManager
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func setNextNavigationScreen(_ showing: Bool) {
        if !showing {
            state.nextNavigationScreen = nil
            reloadItems()
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
    
    func navigateToFocusSessionEditing(list: ProtectedBlockItem) {
        state.nextNavigationScreen = .focusSession(makeFocusSessionViewModel(mode: .editBlockList(list)))
    }
    
    private func makeFocusSessionViewModel(mode: FocusSessionMode) -> FocusSessionViewModel {
        FocusSessionViewModel(
            mode: mode,
            blockItemPersistenceManager: blockItemPersistenceManager,
            deviceActivityRegistrar: deviceActivityRegistrar
        )
    }
    
    private func openFamilyActivitySelectionIfNeeded() {
        if state.blockItems.isEmpty && state.page <= 1 {
            setIsFamilyActivitySheetPresented(true)
        }
    }
}
