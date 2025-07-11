//
//  DeviceActivityHandler.swift
//  FocusTimeActivityMonitor
//
//  Created by Maksym Horobets on 04.07.2025.
//

import SwiftData
import Foundation
import DeviceActivity
import FamilyControls
import ManagedSettings

struct DeviceActivityHandler {
    private let container: ModelContainer
    private let shieldManager: ShieldManager
    
    init(container: ModelContainer, shieldManager: ShieldManager) {
        self.container = container
        self.shieldManager = shieldManager
    }
    
    func handleBlockingStart(for activity: DeviceActivityName) {
        guard let activityIdentifier = try? CodableActivityIdentifier(from: activity) else { return }
        
        let schedule = fetchSchedule(id: activityIdentifier.scheduleID)
        
        // Make sure we have our schedule.
        guard let schedule else { return }

        switch schedule.type {
        case .scheduled(_, let endTime):
            handleRegularBlocking(schedule: schedule,
                                  activity: activity,
                                  activityIdentifier: activityIdentifier,
                                  endTime: endTime)
        case .oneTime:
            handleDurationBlocking()
            // We don't need to handle the end of the interval anymore.
            DeviceActivityCenter().stopMonitoring([activity])
        }
        
    }
    
    private func handleDurationBlocking() {
        Task {
            try? await shieldManager.unblock()
        }
    }
    
    private func handleRegularBlocking(
        schedule: Schedule,
        activity: DeviceActivityName,
        activityIdentifier: CodableActivityIdentifier,
        endTime endTimeComponent: TimeComponents
    ) {
        // Make sure the current day is the block day.
        guard let blockItems = schedule.blockItems, schedule.days.contains(Weekday.currentDay) else { return }
        
        // Block user's selections.
        let selections = blockItems.map(\.blockedContent)
        Task {
            try? await shieldManager.block(specific: selections)
        }
        
        // Sendability workaround since DeviceActivityName is not sendable.
        let stringActivityName = activity.rawValue
        
        if activityIdentifier.isFallback {
            Task {
                while !Task.isCancelled {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    
                    let currentTimeComponent = TimeComponents(from: .now)
                    
                    if currentTimeComponent == endTimeComponent {
                        Task {
                            try? await shieldManager.unblock()
                        }
                        break
                    }
                }
                DeviceActivityCenter()
                    .stopMonitoring(
                        [DeviceActivityName(stringActivityName)]
                    )
            }
            
        }
    }
    
    func handleBlockingEnd(for activity: DeviceActivityName) {
        Task {
            try? await shieldManager.unblock()
        }
    }
    
    private func fetchSchedule(id: UUID) -> Schedule? {
        // Create context from scratch because using mainContext in a
        // non-isolated to MainActor environment is not allowed.
        let context = ModelContext(container)
        
        // Fetch the schedule.
        let fetchDescriptor = FetchDescriptor<Schedule>(
            predicate: #Predicate<Schedule> { $0.id == id }
        )
        
        return try? context.fetch(fetchDescriptor).first
    }
}
