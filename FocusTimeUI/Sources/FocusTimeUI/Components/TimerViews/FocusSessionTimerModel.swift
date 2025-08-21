//
//  File.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 25.07.2025.
//

import Combine
import SwiftUI

@MainActor
public protocol FocusSessionTimerModelDelegate: AnyObject {
    func didUpdateIsPaused(_: Bool)
    func didFinishCountdown()
}

@MainActor
@Observable
public final class FocusSessionTimerModel {
    public struct State {
        var hours: Int
        var minutes: Int
        var seconds: Int
        var formattedTime: String
        
        var isPaused: Bool
        
        public init(
            hours: Int = 0,
            minutes: Int = 0,
            seconds: Int = 0,
            isPaused: Bool
        ) {
            self.hours = hours
            self.minutes = minutes
            self.seconds = seconds
            self.formattedTime = FocusSessionTimerModel.formattedTime(hours: hours,
                                                                      minutes: minutes,
                                                                      seconds: seconds)
            self.isPaused = isPaused
        }
    }
    
    // MARK: - Inputs
    private let deadline: Date

    // MARK: - Internal
    private(set) var state: State
    @ObservationIgnored private var timer: AnyCancellable?
    @ObservationIgnored public weak var delegate: FocusSessionTimerModelDelegate?
    
    // MARK: - Init
    public init(
        state: State,
        deadline: Date,
        delegate: FocusSessionTimerModelDelegate? = nil
    ) {
        self.deadline = deadline
        self.state = state
        self.delegate = delegate
        updateTimeLeft()
        startTimer()
    }

    // MARK: - Timer
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard self?.state.isPaused == false else { return }
                self?.updateTimeLeft()
            }
    }

    private func updateTimeLeft() {
        let remaining = max(Int(deadline.timeIntervalSinceNow), 0)
        if remaining <= 0 {
            delegate?.didFinishCountdown()
            timer?.cancel()
        }
        state.hours = remaining / 3600
        state.minutes = (remaining % 3600) / 60
        state.seconds = remaining % 60
        state.formattedTime = Self.formattedTime(hours: state.hours,
                                                 minutes: state.minutes,
                                                 seconds: state.seconds)
    }

    // MARK: - Controls
    func togglePause() {
        setIsPaused(
            !state.isPaused
        )
    }

    public func stop() {
        timer?.cancel()
        timer = nil
    }
    
    func setHours(_ hours: Int) {
        state.hours = max(0, hours)
    }
    
    func setMinutes(_ minutes: Int) {
        state.minutes = max(0, min(59, minutes))
    }
    
    func setSeconds(_ seconds: Int) {
        state.seconds = max(0, min(59, seconds))
    }
    
    // Set this property from the parent view and then wait for delegate method
    // to fire and set your parent view's property through that.
    public func setIsPaused(_ isPaused: Bool) {
        state.isPaused = isPaused
        delegate?.didUpdateIsPaused(isPaused)
    }

    // MARK: - Convenience
    nonisolated static private func formattedTime(hours: Int, minutes: Int, seconds: Int) -> String {
        String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
