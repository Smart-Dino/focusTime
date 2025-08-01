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
    
    func makeScheduledFocusViewModel() -> ScheduledBlockItemsViewModel {
        ScheduledBlockItemsViewModel(blockItemStore: blockItemStore)
    }
}
