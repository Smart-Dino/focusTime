//
//  HomeViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import Foundation

@MainActor
@Observable
final class HomeViewModel {
    struct State {
        
    }
    
    private(set) var state: State
    
    init(state: State = State()) {
        self.state = state
    }
}
