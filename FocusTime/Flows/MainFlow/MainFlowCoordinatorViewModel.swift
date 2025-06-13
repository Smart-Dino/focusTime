//
//  MainFlowCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import Foundation

enum MainTabScreens: Equatable {
    case home(_ viewModel: FreePlanUpgradeViewModel)
    
    var id: Self { self }
    
    static func == (lhs: PaywallScreens, rhs: PaywallScreens) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home): true
        default: false
        }
    }
}

@MainActor
@Observable
final class PaywallFlowCoordinatorViewModel {
    struct State {
        var currentFlow: MainTabScreens
    }
    private(set) var flowState: State!
    
    #warning("Find out how we would wire up the isPro property to here")
    
    init() {
        self.flowState = State(
            currentFlow: .home(self.makeHomeViewModel())
        )
    }
    
    func makeHomeViewModel() -> FreePlanUpgradeViewModel {
        HomeViewModel()
    }
    
}
