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
    
    @ObservationIgnored weak var delegate: FTTimerDelegate?
    private(set) var isPaused = false
    var isRunning: Bool {
        timer != nil
    }
    private(set) var payload: FTTimerPayload = .init()

    private func ping() {
        guard let deadline else { return }

        let remaining = max(Int(deadline.timeIntervalSinceNow), 0)

        payload.hours = remaining / 3600
        payload.minutes = (remaining % 3600) / 60
        payload.seconds = remaining % 60
        payload.formatted = String(format: "%02d:%02d:%02d", payload.hours, payload.minutes, payload.seconds)

        if remaining <= 0 {
            delegate?.didFinishCountdown()
            cancel()
        }
    }
    
    func setHours(_ hours: Int) {
        payload.hours = hours
    }
    
    func setMinutes(_ minutes: Int) {
        payload.minutes = minutes
    }
    
    func setSeconds(_ seconds: Int) {
        payload.seconds = seconds
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
                try? await Task.sleep(for: .seconds(1), tolerance: .milliseconds(100))
            }
        }
    }

    func pause() {
        isPaused = true
        delegate?.didUpdateIsPaused(true)
    }

    func resume() {
        isPaused = false
        delegate?.didUpdateIsPaused(false)
    }

    func cancel() {
        timer?.cancel()
        timer = nil
        deadline = nil
    }
}
