//
//  MainFlowCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import Foundation
import SwiftData

enum MainTabScreens: Equatable, Hashable {
    case home
    case blocks
    case profile
}

enum MainFlowNavigationRoute: Equatable, Hashable {
    case shieldDebug(_ viewModel: ShieldDebugViewModel)
    
    var id: Self { self }
    
    static func == (lhs: MainFlowNavigationRoute, rhs: MainFlowNavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case (.shieldDebug, .shieldDebug): true
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .shieldDebug:
            hasher.combine(0)
        }
    }
}

@MainActor
@Observable
final class MainFlowCoordinatorViewModel {
    struct State {
        var currentTabScreen: MainTabScreens
        
        let debugViewCountGoal: Int = 5
        var debugViewCount: Int = 0
        var nextNavigationScreen: MainFlowNavigationRoute?
    }
    private(set) var state: State!
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    weak var appFlowDelegate: MainFlowDelegate?
    
    // Cached view models.
    private var cachedHomeViewModel: HomeViewModel?
    private var cachedDraftsBlockItemListViewModel: DraftsBlockItemListViewModel?
    private var cachedShieldDebugViewModel: ShieldDebugViewModel?
    
    #warning("Find out how we would wire up the isPro property to here")
    
    init(
        state: State = State(currentTabScreen: .home),
        blockItemPersistenceManager: BlockItemPersistenceManager,
        appFlowDelegate: MainFlowDelegate?
    ) {
        self.state = state
        self.blockItemPersistenceManager = blockItemPersistenceManager
        self.appFlowDelegate = appFlowDelegate
    }
    
    func setNextNavigationScreen(_ showing: Bool) {
        if !showing {
            state.nextNavigationScreen = nil
        }
    }
    
    func showDebugView() {
        state.nextNavigationScreen = .shieldDebug(makeShieldDebugViewModel())
    }
    
    func setTabScreen(_ screen: MainTabScreens) {
        if state.currentTabScreen == screen {
            state.debugViewCount += 1
        }
        
        if state.debugViewCount >= state.debugViewCountGoal {
            showDebugView()
            state.debugViewCount = .zero
        }
        
        state.currentTabScreen = screen
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        if let cached = cachedHomeViewModel { return cached }
        let viewModel = HomeViewModel(blockItemPersistenceManager: blockItemPersistenceManager, delegate: self)
        cachedHomeViewModel = viewModel
        return viewModel
    }
    
    func makeDraftsBlockItemListViewModel() -> DraftsBlockItemListViewModel {
        if let cached = cachedDraftsBlockItemListViewModel { return cached }
        let viewModel = DraftsBlockItemListViewModel(blockItemPersistenceManager: blockItemPersistenceManager)
        cachedDraftsBlockItemListViewModel = viewModel
        return viewModel
    }
    
    func makeShieldDebugViewModel() -> ShieldDebugViewModel {
        if let cached = cachedShieldDebugViewModel { return cached }
        let viewModel = ShieldDebugViewModel(blockItemPersistenceManager: blockItemPersistenceManager)
        cachedShieldDebugViewModel = viewModel
        return viewModel
    }
    
    func requestPaywall() {
        appFlowDelegate?.didRequestPaywallPlanSelection()
    }
    
}

extension MainFlowCoordinatorViewModel: HomeViewDelegate {
    func didRequestPaywall() {
        appFlowDelegate?.didRequestPaywallPlanSelection()
    }
}
