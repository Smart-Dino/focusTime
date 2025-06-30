//
//  ScheduledFocusListViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import Foundation

@MainActor
@Observable
final class ScheduledFocusListViewModel {
    struct State {
        var items = [Schedule]()
    }
    
    private(set) var state: State
    private let scheduleStore: ScheduleStore
    
    init(state: State = State(), scheduleStore: ScheduleStore) {
        self.state = state
        self.scheduleStore = scheduleStore
    }
    
    func insertTestItemsIntoDatabase() async {
        for _ in 0..<100 {
            let schedule = Schedule(
                emoji: "🏠",
                name: "Spend time with family",
                days: [.saturday, .sunday],
                startTime: TimeComponents(hour: 17, minute: 00)!,
                endTime: TimeComponents(hour: 19, minute: 00)!)
            
            try? await scheduleStore.insert(schedule)
        }
        try? await MainActor.run {
            state.items = try scheduleStore.fetchAll()
        }
    }
}
