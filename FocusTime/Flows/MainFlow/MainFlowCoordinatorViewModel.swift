//
//  MainFlowCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import Foundation

enum MainTabScreens: Equatable, Hashable {
    case home
    case blocks
    case profile
    
    var id: Self { self }
}

@MainActor
@Observable
final class MainFlowCoordinatorViewModel {
    struct State {
        var currentScreen: MainTabScreens
    }
    private(set) var flowState: State!
    
    #warning("Find out how we would wire up the isPro property to here")
    
    init() {
        self.flowState = State(
            currentScreen: .home
        )
    }
    
    func setScreen(_ screen: MainTabScreens) {
        flowState.currentScreen = screen
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel()
    }
    
}
