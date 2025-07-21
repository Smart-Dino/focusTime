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
        var error: Error? = nil
        var page = 0
        var items = [ProtectedSchedule]()
    }
    
    private(set) var state: State
    private let scheduleStore: ScheduleStore
    
    var fetchTask: Task<Void, Never>?
    
    init(
        state: State = State(),
        modelContainer: ModelContainer
    ) {
        self.state = state
        self.scheduleStore = ScheduleStore(modelContainer: modelContainer)
    }
    
    func keepShowingError(showError: Bool) {
        if !showError {
            state.error = nil
        }
    }
    
    func insertTestItemsIntoDatabase() async {
        Task.detached(priority: .userInitiated) {
            do {
                let itemsToInsert = Array(
                    repeating: ProtectedSchedule(
                        emoji: "🏠",
                        name: "Spend time with family",
                        days: [.saturday, .sunday],
                        startTime: TimeComponents(hour: 17, minute: 00)!,
                        endTime: TimeComponents(hour: 19, minute: 00)!
                    ),
                    count: 100
                )
                try await self.scheduleStore.insertBatch(itemsToInsert)
                await self.fetchNextPage()
                await MainActor.run {
                    self.state.error = nil
                }
            } catch {
                await MainActor.run {
                    self.state.error = error
                }
            }
        }
    }
    
    private func fetchNextPage() {
        guard fetchTask == nil else { return }
        self.fetchTask = Task.detached(priority: .userInitiated) {
            do {
                let insertedItems = try await self.scheduleStore.fetch(page: self.state.page)
                await MainActor.run {
                    self.state.items.append(contentsOf: insertedItems)
                    self.state.page += 1
                    self.state.error = nil
                    self.fetchTask = nil
                    print("Items on screen: \(self.state.items.count)")
                }
            } catch {
                await MainActor.run {
                    self.state.error = error
                    self.fetchTask = nil
                    print("Failed to fetch page \(self.state.page): \(error)")
                }
            }
        }
    }
    
    func hasReachEndOfList(schedule: ProtectedSchedule) {
        if schedule.id == state.items.last?.id {
            fetchNextPage()
        }
    }
}
