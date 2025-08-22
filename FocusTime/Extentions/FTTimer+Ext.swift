//
//  FTTimer+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.08.2025.
//

import Foundation
import FocusTimeUI

extension FTTimer {
    func startTimer(for blockItem: ProtectedBlockItem) {
        var deadline: Date?
        switch blockItem.type {
        case .duration(_, _, let suspendedUntil, _):
            deadline = suspendedUntil
        case .scheduled(_, _, _, _, let suspendedUntil):
            deadline = suspendedUntil
        }
        
        if let checkedDeadline = deadline {
            let timeComponents = try? TimeComponents(from: checkedDeadline)
            if let dateComponents = timeComponents?.dateComponents {
                deadline = Calendar.current.date(
                    bySettingHour: dateComponents.hour ?? 0,
                    minute: dateComponents.minute ?? 0,
                    second: dateComponents.second ?? 0,
                    of: checkedDeadline
                )
            }
        }
        
        guard let timeLeft = blockItem.type.secondsToIntervalEndIfShouldBeRunning(),
              timeLeft >= 1 && blockItem.state.isActive else {
            self.start(
                deadline: Date.now,
                isInitiallyPaused: true
            )
            return
        }
        
        self.start(
            deadline: deadline ?? Date.now.addingTimeInterval(TimeInterval(timeLeft)),
            isInitiallyPaused: blockItem.state == .suspendedIndefinitely
        )
    }
}
