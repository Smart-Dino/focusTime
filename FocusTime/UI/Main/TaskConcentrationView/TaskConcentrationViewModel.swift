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
        var timerIsPaused: Bool = true
        
        var timerControlButtonIcon = TaskConcentrationView.Constants.Icons.pause
        var timerControlButtonTitle = TaskConcentrationView.Constants.Strings.resumeButtonTitle
    }
    
    private(set) var state: State
    let timerModel: FocusSessionTimerModel
    
    init(
        state: State = State(),
        timerModel: FocusSessionTimerModel
    ) {
        self.state = state
        self.timerModel = timerModel
        
        timerModel.delegate = self
    }
    
    func updateUIBasedOnTimerState() {
        if state.timerIsPaused {
            state.timerControlButtonIcon = TaskConcentrationView.Constants.Icons.pause
            state.timerControlButtonTitle = TaskConcentrationView.Constants.Strings.resumeButtonTitle
        } else {
            state.timerControlButtonIcon = TaskConcentrationView.Constants.Icons.play
            state.timerControlButtonTitle = TaskConcentrationView.Constants.Strings.pauseButtonTitle
        }
    }
    
    func toggleSession() {
        if state.timerIsPaused {
            resumeSession()
        } else {
            pauseSession()
        }
        
        updateUIBasedOnTimerState()
    }
    
    func pauseSession() {
        #warning("Notify DeviceActivityRegistrar of pausing")
        timerModel.setIsPaused(true)
        // Delegation will set the state.
    }
    
    func resumeSession() {
        #warning("Notify DeviceActivityRegistrar of resumption")
        timerModel.setIsPaused(false)
        // Delegation will set the state.
    }
    
    func endSession() {
        #warning("Notify DeviceActivityRegistrar of stopping and unregistering the session")
    }
    
}

extension TaskConcentrationViewModel: FocusSessionTimerModelDelegate {
    func didUpdateIsPaused(_ timerIsPaused: Bool) {
        state.timerIsPaused = timerIsPaused
        updateUIBasedOnTimerState()
    }
}
