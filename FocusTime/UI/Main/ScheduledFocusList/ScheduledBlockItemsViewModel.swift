//
//  ScheduledBlockItemsViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import SwiftData
import Foundation
import FamilyControls

enum ScheduledBlockItemsViewNavigationRoute: Equatable, Hashable {
    case focusSession(_ viewModel: FocusSessionViewModel)
    
    var id: Self { self }
    
    static func == (lhs: ScheduledBlockItemsViewNavigationRoute, rhs: ScheduledBlockItemsViewNavigationRoute) -> Bool {
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
final class ScheduledBlockItemsViewModel {
    struct State {
        let proState: ProState
        var error: Error? = nil
        
        var page = 0
        let amountPerPage = SharedAppValues.amountOfItemsPerPage
        var items = [ProtectedBlockItem]()
        
        var nextNavigationScreen: ScheduledBlockItemsViewNavigationRoute?
    }

    private(set) var state: State
    
    private let paywallPresenter: PaywallPresenter
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    private var fetchTask: Task<Void, Never>?
    
    private var analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()

    init(
        state: State,
        paywallPresenter: PaywallPresenter,
        deviceActivityRegistrar: DeviceActivityRegistrar,
        blockItemPersistenceManager: BlockItemPersistenceManager
    ) {
        self.state = state
        
        self.paywallPresenter = paywallPresenter
        self.deviceActivityRegistrar = deviceActivityRegistrar
        self.blockItemPersistenceManager = blockItemPersistenceManager
    }
    
    func setNextNavigationScreen(_ showing: Bool) {
        if !showing {
            state.nextNavigationScreen = nil
        }
    }
    
    func navigateToFocusSessionNewItem() {
        /// - Analytics
        analyticsManager.logEvent(name: "scheduled_list_navigate_to_new_focus_session", parameters: nil)
      
        state.nextNavigationScreen = .focusSession(makeFocusSessionViewModel(mode: .addScheduledBlockList))
    }

    private func reloadItems() {
        fetchTask?.cancel()
        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.reloadPaginatedData(
                    totalPages: state.page,
                    packSize: state.amountPerPage
                )
                state.items = newItems.filter(\.isScheduled)
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
                ).filter(\.isScheduled)

                let existingIDs = Set(state.items.map(\.id))
                state.items.append(contentsOf: newItems.filter { !existingIDs.contains($0.id) })
                
                if !(newItems.count < state.amountPerPage) {
                    state.page += 1
                }
                
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
        
        /// - Analytics
        analyticsManager.logEvent(name: "scheduled_list_error_visibility_changed", parameters: ["is_visible": isVisible])
    }

    func loadData() {
        /// - Analytics
        analyticsManager.logEvent(name: "scheduled_list_screen_loaded", parameters: nil)
        
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
    
    private func makeFocusSessionViewModel(mode: FocusSessionMode) -> FocusSessionViewModel {
        FocusSessionViewModel(
            mode: mode,
            proState: state.proState,
            paywallPresenter: paywallPresenter,
            blockItemPersistenceManager: blockItemPersistenceManager,
            deviceActivityRegistrar: deviceActivityRegistrar
        )
    }
}
