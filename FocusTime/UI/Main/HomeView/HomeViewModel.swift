//
//  HomeViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import SwiftUI
import SwiftData
import Foundation

@MainActor
@Observable
final class HomeViewModel {
    struct State {
        var nextNavigationScreen: MainScreens?
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
