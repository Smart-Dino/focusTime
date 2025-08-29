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
    case focusSession(_ viewModel: FocusSessionViewModel)
    
    var id: Self { self }
    
    static func == (lhs: MainFlowNavigationRoute, rhs: MainFlowNavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case let (.focusSession(lVM), .focusSession(rVM)):
            lVM === rVM // compare by reference if class
        default:
            false
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
final class MainFlowCoordinatorViewModel {
    struct State {
        enum MainTabScreens: Identifiable, Equatable, Hashable {
            case home(viewModel: HomeViewModel)
            case drafts(viewModel: DraftsBlockItemListViewModel)
            case none

            var id: Int { hashValue }

            static func == (lhs: MainTabScreens, rhs: MainTabScreens) -> Bool {
                switch (lhs, rhs) {
                case let (.home(lVM), .home(rVM)):
                    lVM === rVM // reference equality if class
                case let (.drafts(lVM), .drafts(rVM)):
                    lVM === rVM // reference equality if class
                case (.none, .none):
                    true
                default:
                    false
                }
            }

            func hash(into hasher: inout Hasher) {
                switch self {
                case let .home(vm):
                    hasher.combine(0)
                    hasher.combine(ObjectIdentifier(vm))
                case let .drafts(vm):
                    hasher.combine(1)
                    hasher.combine(ObjectIdentifier(vm))
                case .none:
                    hasher.combine(2)
                }
            }
        }
        var currentTabScreen: MainTabScreens
        var tabViewModels: [MainTabScreens] = .init()
        
        var proState: ProState
        
        var nextNavigationScreen: MainFlowNavigationRoute?
    }
    
    private(set) var state: State
    private let timer: FTTimer
    
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    weak var appFlowDelegate: MainFlowDelegate?
    
    init(
        state: State,
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
                    state: .init(timer: timer),
                    deviceActivityRegistrar: deviceActivityRegistrar,
                    blockItemPersistenceManager: blockItemPersistenceManager,
                    delegate: self
                )
            ),
            State.MainTabScreens.drafts(
                viewModel: DraftsBlockItemListViewModel(
                    state: .init(timer: timer),
                    deviceActivityRegistrar: deviceActivityRegistrar,
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
    
    func showNewBlockListView() {
        state.nextNavigationScreen = .focusSession(makeFocusSessionViewModel())
    }
    
    func setTabScreen(_ screen: State.MainTabScreens) {
        state.currentTabScreen = screen
    }
    
    func makeFocusSessionViewModel() -> FocusSessionViewModel {
        FocusSessionViewModel(
            mode: .addBlockList,
            blockItemPersistenceManager: blockItemPersistenceManager,
            deviceActivityRegistrar: deviceActivityRegistrar
        )
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
