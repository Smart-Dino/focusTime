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
    
    var id: Self { self }
}

enum MainScreens: Equatable, Hashable {
    case scheduledFocusList(_ viewModel: ScheduledFocusListViewModel)
    
    var id: Self { self }
    
    static func == (lhs: MainScreens, rhs: MainScreens) -> Bool {
        switch (lhs, rhs) {
        case (.scheduledFocusList, .scheduledFocusList): true
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .scheduledFocusList:
            hasher.combine(0)
        }
    }
}

@MainActor
@Observable
final class MainFlowCoordinatorViewModel {
    struct State {
        var currentTabScreen: MainTabScreens
        var currentPath: [MainScreens] = []
    }
    private(set) var flowState: State!
    private let modelContainer: ModelContainer
    
    #warning("Find out how we would wire up the isPro property to here")
    
    init(
        flowState: State = State(currentTabScreen: .home),
        modelContainer: ModelContainer
    ) {
        self.flowState = flowState
        self.modelContainer = modelContainer
    }
    
    func setScreens(_ screens: [MainScreens]) {
        flowState.currentPath = screens
    }
    
    func setTabScreen(_ screen: MainTabScreens) {
        flowState.currentTabScreen = screen
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(modelContainer: modelContainer)
    }
    
    func makeAppBlockListViewModel() -> AppBlockingListViewModel {
        AppBlockingListViewModel(modelContainer: modelContainer)
    }
    
}
