//
//  AppBlockingListViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import Foundation

import Foundation

@MainActor
@Observable
final class AppBlockingListViewModel {
    struct State {
        
    }
    
    private(set) var state: State
    
    init(state: State = State()) {
        self.state = state
    }
}
