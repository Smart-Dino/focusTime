//
//  HomeViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import SwiftUI
import SwiftData
import Foundation

enum HomeViewNavigationRoute: Equatable, Hashable {
    case scheduledFocusList(_ viewModel: ScheduledBlockItemsViewModel)
    
    var id: Self { self }
    
    static func == (lhs: HomeViewNavigationRoute, rhs: HomeViewNavigationRoute) -> Bool {
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
final class HomeViewModel {
    struct State {
        var nextNavigationScreen: HomeViewNavigationRoute?
    }
    
    private(set) var state: State
    private let blockItemStore: BlockItemStore
    weak var delegate: HomeViewDelegate?
    
    init(
        state: State = State(),
        modelContainer: ModelContainer,
        delegate: HomeViewDelegate?
    ) {
        self.state = state
        self.blockItemStore = BlockItemStore(modelContainer: modelContainer)
        self.delegate = delegate
    }
    
    func setNextNavigationScreen(_ showing: Bool) {
        if !showing {
            state.nextNavigationScreen = nil
        }
    }
    
    func showScheduledFocusView() {
        state.nextNavigationScreen = .scheduledFocusList(makeScheduledFocusViewModel())
    }
    
    private func makeScheduledFocusViewModel() -> ScheduledBlockItemsViewModel {
        ScheduledBlockItemsViewModel(blockItemStore: blockItemStore)
    }
}
