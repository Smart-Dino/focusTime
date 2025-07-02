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
        var items = [ProtectedSchedule]()
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
            let blockItemStore = ScheduleStore(modelContainer: self.modelContainer)
            let itemsToInsert = Array(
                repeating: ProtectedSchedule(
                    emoji: "🏠",
                    name: "Spend time with family",
                    days: [.saturday, .sunday],
                    startTime: TimeComponents(hour: 17, minute: 00)!,
                    endTime: TimeComponents(hour: 19, minute: 00)!
                ),
                count: 100000
            )
            try? await blockItemStore.insertBatch(itemsToInsert)
            let insertedItems = try? await blockItemStore.fetch()
            await MainActor.run {
                self.state.items = insertedItems ?? []
            }
        }
    }
}
