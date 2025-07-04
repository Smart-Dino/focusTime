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
        var page = 0
        var items = [ProtectedSchedule]()
    }
    
    private(set) var state: State
    private let modelContainer: ModelContainer
    
    var fetchTask: Task<Void, Never>?
    
    init(
        state: State = State(),
        modelContainer: ModelContainer
    ) {
        self.state = state
        self.modelContainer = modelContainer
    }
    
    func insertTestItemsIntoDatabase() async throws {
        Task.detached(priority: .userInitiated) {
            let scheduleStore = ScheduleStore(modelContainer: self.modelContainer)
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
            try await scheduleStore.insertBatch(itemsToInsert)
            await self.fetchNextPage()
        }
    }
    
    private func fetchNextPage() {
        guard fetchTask == nil else { return }
        self.fetchTask = Task.detached(priority: .userInitiated) {
            let scheduleStore = ScheduleStore(modelContainer: self.modelContainer)
            let insertedItems = try? await scheduleStore.fetch(page: self.state.page)
            await MainActor.run {
                self.state.items.append(contentsOf: insertedItems ?? [])
                self.state.page += 1
                self.fetchTask = nil
                print("Items on screen: \(self.state.items.count)")
            }
        }
    }
    
    func hasReachEndOfList(schedule: ProtectedSchedule) {
        if schedule.id == state.items.last?.id {
            fetchNextPage()
        }
    }
}
