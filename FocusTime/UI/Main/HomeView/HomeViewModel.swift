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
    
    init(
        state: State = State(),
        modelContainer: ModelContainer
    ) {
        self.state = state
        self.blockItemStore = BlockItemStore(modelContainer: modelContainer)
    }
    
    func makeScheduledFocusViewModel() -> ScheduledBlockItemsViewModel {
        ScheduledBlockItemsViewModel(blockItemStore: blockItemStore)
    }
}
