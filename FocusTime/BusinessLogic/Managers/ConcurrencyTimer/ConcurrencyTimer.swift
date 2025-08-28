//
//  ConcurrencyTimer.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.08.2025.
//

import SwiftUI
import FocusTimeUI

@Observable
final class ConcurrencyTimer: FTTimer {
    @ObservationIgnored private var timer: Task<Void, Never>?
    @ObservationIgnored private var deadline: Date?
    
    private(set) var isPaused = false
    var isRunning: Bool {
        timer != nil
    }
    private(set) var payload: FTTimerPayload = .init()

    private func ping() {
        guard let deadline else { return }

        let remaining = max(Int(deadline.timeIntervalSinceNow), 0)

        payload.setHours(remaining / 3600)
        payload.setMinutes((remaining % 3600) / 60)
        payload.setSeconds(remaining % 60)
        let formatted = String(
            format: "%02d:%02d:%02d",
            payload.hours,
            payload.minutes,
            payload.seconds
        )
        payload.setFormatted(formatted)

        if remaining <= 0 {
            cancel()
        }
    }

    func start(deadline: Date, isInitiallyPaused: Bool) {
        self.deadline = deadline
        self.isPaused = isInitiallyPaused

        timer?.cancel()
        ping()
        timer = Task(priority: .utility) { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                if !isPaused {
                    ping()
                }
                try? await Task.sleep(for: .seconds(1), tolerance: SharedAppValues.timerLeeway)
            }
        }
    }

    func pause() {
        isPaused = true
    }

    func resume() {
        isPaused = false
    }

    func cancel() {
        timer?.cancel()
        timer = nil
        deadline = nil
    }
}
