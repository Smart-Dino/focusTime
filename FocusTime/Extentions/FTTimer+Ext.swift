//
//  FTTimer+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.08.2025.
//

import Foundation
import FocusTimeUI

extension FTTimer {
    func startTimer(for blockItem: ProtectedBlockItem, withSuspensionCountdown: Bool) {

        // Ensure the block is active and has a valid time remaining.
        guard let timeLeft = blockItem.type.secondsToIntervalEndIfShouldBeRunning(),
              timeLeft >= 1,
              blockItem.state.isActive else {
            // If conditions are not met, default to a non-counting, paused timer.
            self.start(deadline: Date.now, isInitiallyPaused: true)
            return
        }

        // Determine the timer's properties based on the block item's state.
        let deadline = calculateDeadline(
            for: blockItem,
            timeLeft: timeLeft,
            useSuspensionTime: withSuspensionCountdown
        )
        let isInitiallyPaused = shouldStartPaused(
            for: blockItem,
            useSuspensionTime: withSuspensionCountdown
        )

        // Start the timer with the calculated configuration.
        self.start(deadline: deadline, isInitiallyPaused: isInitiallyPaused)
    }

    // MARK: - Private Helper Methods
    /// Determines if the timer should start in a paused state.
    private func shouldStartPaused(for blockItem: ProtectedBlockItem, useSuspensionTime: Bool) -> Bool {
        switch blockItem.state {
        case .running: false

        case .suspended:
            
            switch blockItem.type {
            case .scheduled: false
            case .duration: !useSuspensionTime
            }
            
        case .suspendedIndefinitely, .inactive: true
            
        }
    }

    private func calculateDeadline(for blockItem: ProtectedBlockItem, timeLeft: Int, useSuspensionTime: Bool) -> Date {
        // If counting down a suspension, the deadline is the date the suspension ends.
        var deadline: Date?
        if useSuspensionTime, let suspensionEndDate = blockItem.type.suspensionEndDate {
            let timeComponents = try? TimeComponents(from: suspensionEndDate)
            if let dateComponents = timeComponents?.dateComponents {
                deadline = Calendar.current.date(
                    bySettingHour: dateComponents.hour ?? 0,
                    minute: dateComponents.minute ?? 0,
                    second: dateComponents.second ?? 0,
                    of: suspensionEndDate
                )
            }
        }

        // Otherwise, the deadline is the current time plus the remaining interval duration.
        return deadline ?? Date.now.addingTimeInterval(TimeInterval(timeLeft))
    }
}
