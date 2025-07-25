//
//  File.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 25.07.2025.
//

import Combine
import SwiftUI

@MainActor
@Observable
public final class FocusSessionTimerModel {
    public struct State {
        var hours: Int
        var minutes: Int
        var seconds: Int
        var formattedTime: String
        
        var isPaused: Binding<Bool>
        
        public init(
            hours: Int = 0,
            minutes: Int = 0,
            seconds: Int = 0,
            isPaused: Binding<Bool>
        ) {
            self.hours = hours
            self.minutes = minutes
            self.seconds = seconds
            self.formattedTime = String()
            self.isPaused = isPaused
        }
    }
    
    // MARK: - Inputs
    private let deadline: Date

    // MARK: - Internal
    private(set) var state: State
    @ObservationIgnored private var timer: AnyCancellable?
    
    // MARK: - Init
    public init(
        state: State,
        deadline: Date
    ) {
        self.deadline = deadline
        self.state = state
        updateTimeLeft()
        startTimer()
    }

    // MARK: - Timer
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard self?.state.isPaused.wrappedValue == false else { return }
                self?.updateTimeLeft()
            }
    }

    private func updateTimeLeft() {
        let remaining = max(Int(deadline.timeIntervalSinceNow), 0)
        state.hours = remaining / 3600
        state.minutes = (remaining % 3600) / 60
        state.seconds = remaining % 60
        state.formattedTime = formattedTime()
    }

    // MARK: - Controls
    func togglePause() {
        state.isPaused.wrappedValue.toggle()
    }

    func stop() {
        timer?.cancel()
        timer = nil
    }
    
    public func setHours(_ hours: Int) {
        state.hours = hours
    }
    
    public func setMinutes(_ minutes: Int) {
        state.minutes = minutes
    }
    
    public func setSeconds(_ seconds: Int) {
        state.seconds = seconds
    }
    
    public func setIsPaused(_ isPaused: Bool) {
        state.isPaused.wrappedValue = isPaused
    }

    // MARK: - Convenience
    private func formattedTime() -> String {
        String(format: "%02d:%02d:%02d", state.hours, state.minutes, state.seconds)
    }
}
