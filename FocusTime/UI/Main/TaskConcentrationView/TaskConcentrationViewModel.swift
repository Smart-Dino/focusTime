//
//  TaskConcentrationViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 28.07.2025.
//

import SwiftUI
import FocusTimeUI

@MainActor
@Observable
final class TaskConcentrationViewModel {
    struct State {
        enum Phase {
            case focus(
                title: String,
                subtitle: String,
                timerTitle: String,
                runningTitle: String,
                pausedTitle: String,
                runningIcon: String,
                pausedIcon: String
            )
            case breakTransition(
                title: String,
                subtitle: String
            )
            case breakTime(
                title: String,
                subtitle: String,
                timerTitle: String,
                buttonTitle: String
            )
            case almostDone(
                title: String,
                subtitle: String,
                message: String,
                buttonTitle: String
            )
            case finished(
                title: String,
                buttonTitle: String
            )
        }

        var error: Error?
        var item: ProtectedBlockItem
        var timerIsPaused: Bool = true
        
        var breakTimer: FTTimer? = nil
        var phase: Phase = .focus
    }
    
    private(set) var state: State
    let timer: FTTimer
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    
    init(
        state: State,
        timer: FTTimer,
        deviceActivityRegistrar: DeviceActivityRegistrar
    ) {
        self.state = state
        self.timer = timer
        self.deviceActivityRegistrar = deviceActivityRegistrar
        
        self.timer.delegate = self
        self.state.timerIsPaused = timer.isPaused
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func setTimerIsPaused(_ pause: Bool) {
        if pause {
            timer.pause()
        } else {
                // Since duration blocking updates it's deadline after resumption we need to recreate the timer.
            timer.startTimer(for: state.item)
            timer.resume()

        }
    }
    
    // MARK: - Navigation
    func moveTo(_ phase: State.Phase) {
        withAnimation {
            state.phase = phase
        }
    }
    
    func startABreak(for seconds: Int = SharedAppValues.breakTimeDuration) {
        
    }
    
    func pauseSession() {
        #warning("Notify DeviceActivityRegistrar of pausing")
        timer.pause()
        // Delegation will set the state.
    }
    
    func resumeSession() {
        #warning("Notify DeviceActivityRegistrar of resumption")
        timer.resume()
        // Delegation will set the state.
    }
    
    func endSession() {
        #warning("Notify DeviceActivityRegistrar of stopping and unregistering the session")
    }
    
}

extension TaskConcentrationViewModel: FTTimerDelegate {
    func didUpdateIsPaused(_ pause: Bool) {
        Task {
            do {
                pause
                ? try await deviceActivityRegistrar.suspendActivity(for: state.item)
                : try await deviceActivityRegistrar.resumeActivity(for: state.item)

                self.state.timerIsPaused = pause
            } catch {
                state.error = error
            }
        }
    }
    
    func didFinishCountdown() {
        timer.cancel()
        moveTo(.breakTransition)
    }
}
