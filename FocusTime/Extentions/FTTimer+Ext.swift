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
        let deadline: Date?
        switch blockItem.type {
        case .duration(_, _, let suspendedUntil, _):
            deadline = suspendedUntil
        case .scheduled(_, _, _, _, let suspendedUntil):
            deadline = suspendedUntil
        }
        
        guard let timeLeft = blockItem.type.secondsToIntervalEndIfShouldBeRunning(),
              timeLeft >= 1 && blockItem.isActive else { return }
        
        self.start(
            deadline: deadline ?? Date.now.addingTimeInterval(TimeInterval(timeLeft)),
            isInitiallyPaused: blockItem.isPaused
        )
    }
}
