//
//  HomeViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import SwiftData
import Foundation

@MainActor
@Observable
final class HomeViewModel {
    struct State {
        
    }
    
    private(set) var state: State
    private let modelContainer: ModelContainer
    
    init(
        state: State = State(),
        modelContainer: ModelContainer
    ) {
        self.state = state
        self.modelContainer = modelContainer
    }
    
    func makeScheduledFocusViewModel() -> ScheduledFocusListViewModel {
        ScheduledFocusListViewModel(modelContainer: modelContainer)
    }
}
