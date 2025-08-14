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
        guard let timeLeft = blockItem.type.secondsToIntervalEndIfShouldBeRunning(),
              timeLeft >= 1 else { return }
        
        self.start(
            deadline: .now.addingTimeInterval(TimeInterval(timeLeft)),
            isInitiallyPaused: blockItem.isPaused
        )
    }
}
