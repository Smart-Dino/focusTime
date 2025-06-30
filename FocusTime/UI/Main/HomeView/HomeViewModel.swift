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
    private let scheduleStore: ScheduleStore
    
    init(state: State = State(), scheduleStore: ScheduleStore) {
        self.state = state
        self.scheduleStore = scheduleStore
    }
    
    func makeScheduledFocusViewModel() -> ScheduledFocusListViewModel {
        ScheduledFocusListViewModel(scheduleStore: scheduleStore)
    }
}
