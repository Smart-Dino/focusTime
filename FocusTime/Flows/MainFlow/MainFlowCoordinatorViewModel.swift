//
//  MainFlowCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import SwiftData
import Foundation
import FocusTimeUI

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
        enum MainTabScreens: Identifiable, Equatable, Hashable {
            case home(viewModel: HomeViewModel)
            case drafts(viewModel: DraftsBlockItemListViewModel)
            case none
            
            var id: Int { hashValue }
            
            static func == (lhs: MainTabScreens, rhs: MainTabScreens) -> Bool {
                switch (lhs, rhs) {
                case (.home, .home): true
                case (.drafts, .drafts): true
                case (.none, .none): true
                default: false
                }
            }
            
            func hash(into hasher: inout Hasher) {
                switch self {
                case .home:
                    hasher.combine(0)
                case .drafts:
                    hasher.combine(1)
                case .none:
                    hasher.combine(2)
                }
            }
        }
        var currentTabScreen: MainTabScreens
        var tabViewModels: [MainTabScreens] = .init()
        
        let debugViewCountGoal: Int = 5
        var debugViewCount: Int = 0
        var nextNavigationScreen: MainFlowNavigationRoute?
    }
    
    private(set) var state: State
    let timer: FTTimer
    
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    weak var appFlowDelegate: MainFlowDelegate?
    
    #warning("Find out how we would wire up the isPro property to here")
    
    init(
        state: State = State(currentTabScreen: .none),
        timer: FTTimer = ConcurrencyTimer(),
        deviceActivityRegistrar: DeviceActivityRegistrar,
        blockItemPersistenceManager: BlockItemPersistenceManager,
        appFlowDelegate: MainFlowDelegate?
    ) {
        self.state = state
        self.timer = timer
        self.deviceActivityRegistrar = deviceActivityRegistrar
        self.blockItemPersistenceManager = blockItemPersistenceManager
        self.appFlowDelegate = appFlowDelegate
        
        setupFlow()
    }
    
    func setupFlow() {
        state.tabViewModels = [
            State.MainTabScreens.home(
                viewModel: HomeViewModel(
                    timer: timer,
                    deviceActivityRegistrar: deviceActivityRegistrar,
                    blockItemPersistenceManager: blockItemPersistenceManager,
                    delegate: self
                )
            ),
            State.MainTabScreens.drafts(
                viewModel: DraftsBlockItemListViewModel(
                    timer: timer,
                    blockItemPersistenceManager: blockItemPersistenceManager
                )
            )
        ]
        state.currentTabScreen = state.tabViewModels.first!
    }
    
    func setNextNavigationScreen(_ showing: Bool) {
        if !showing {
            state.nextNavigationScreen = nil
        }
    }
    
    func showDebugView() {
        state.nextNavigationScreen = .shieldDebug(makeShieldDebugViewModel())
    }
    
    func setTabScreen(_ screen: State.MainTabScreens) {
        if state.currentTabScreen == screen {
            state.debugViewCount += 1
        }
        
        if state.debugViewCount >= state.debugViewCountGoal {
            showDebugView()
            state.debugViewCount = .zero
        }
        
        state.currentTabScreen = screen
    }
    
    func makeShieldDebugViewModel() -> ShieldDebugViewModel {
        ShieldDebugViewModel(blockItemPersistenceManager: blockItemPersistenceManager)
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
