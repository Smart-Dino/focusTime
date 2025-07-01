//
//  ScheduledFocusListViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import Foundation
import SwiftData

@MainActor
@Observable
final class ScheduledFocusListViewModel {
    struct State {
        var items = [Schedule]()
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
    
    func insertTestItemsIntoDatabase() async {
        Task.detached(priority: .userInitiated) {
            let scheduleStore = ScheduleStore(modelContainer: self.modelContainer)
            for _ in 0..<100 {
                let schedule = ProtectedSchedule(
                    emoji: "🏠",
                    name: "Spend time with family",
                    days: [.saturday, .sunday],
                    startTime: TimeComponents(hour: 17, minute: 00)!,
                    endTime: TimeComponents(hour: 19, minute: 00)!)
                
                try? await scheduleStore.insert(schedule)
            }
            try? await MainActor.run {
                self.state.items = try self.modelContainer.mainContext.fetch(.init())
            }
        }
    }
}
