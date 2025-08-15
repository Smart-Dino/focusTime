//
//  TaskConcentrationViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 28.07.2025.
//

import Foundation
import FocusTimeUI

@MainActor
@Observable
final class TaskConcentrationViewModel {
    struct State {
        var error: Error?
        
        var item: ProtectedBlockItem
        var timerIsPaused: Bool = true
        
        var timerControlButtonIcon = TaskConcentrationView.Constants.Icons.pause
        var timerControlButtonTitle = TaskConcentrationView.Constants.Strings.resumeButtonTitle
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
    
    func updateUIBasedOnTimerState() {
        if state.timerIsPaused {
            state.timerControlButtonIcon = TaskConcentrationView.Constants.Icons.play
            state.timerControlButtonTitle = TaskConcentrationView.Constants.Strings.resumeButtonTitle
        } else {
            state.timerControlButtonIcon = TaskConcentrationView.Constants.Icons.pause
            state.timerControlButtonTitle = TaskConcentrationView.Constants.Strings.pauseButtonTitle
        }
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
                self.updateUIBasedOnTimerState()
            } catch {
                state.error = error
            }
        }
    }
    
    func didFinishCountdown() {
        timer.cancel()
    }
}
