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
                subtitle: String
            )
        }

        var error: Error?
        var item: ProtectedBlockItem
        var timerIsPaused: Bool = true
        
        var phase: Phase = .focus
    }
    
    private(set) var state: State
    let timer: FTTimer
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    
    private var dbChangesNotificationTask: Task<Void, Never>?
    
    init(
        state: State,
        timer: FTTimer,
        deviceActivityRegistrar: DeviceActivityRegistrar,
        blockItemPersistenceManager: BlockItemPersistenceManager
    ) {
        self.state = state
        self.timer = timer
        self.deviceActivityRegistrar = deviceActivityRegistrar
        self.blockItemPersistenceManager = blockItemPersistenceManager
        
        self.timer.delegate = self
        self.state.timerIsPaused = timer.isPaused

        Task {
            subscribeToDB()
        }
    }
    
    func subscribeToDB() {
        dbChangesNotificationTask = Task {
            for await _ in await blockItemPersistenceManager.contextChangesStream() {
                try? await Task.sleep(for: SharedAppValues.debounceAfterDBRefreshed)
                #warning("Empty implementation")
            }
        }
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func toggleTimerIsPaused() async {
        if timer.isPaused {
            await resumeFromBreak()
            moveTo(.focus)
        } else {
            await startABreak()
            moveTo(.breakTransition)
        }
    }
    
    func moveTo(_ phase: State.Phase) {
        withAnimation {
            state.phase = phase
        }
    }
    
    func startTimerPauseTimer() {
        timer.resume()
    }
    
    func startABreak(for seconds: Int = SharedAppValues.breakTimeDuration) async {
        do {
            try await deviceActivityRegistrar.suspendActivity(for: state.item, forSeconds: seconds)
            timer.startTimer(for: state.item)
            timer.pause()
        } catch {
            state.error = error
        }
    }
    
    func resumeFromBreak() async {
        do {
            // Since duration blocking updates it's deadline after resumption we need to recreate the timer.
            try await deviceActivityRegistrar.cancelScheduledResume(for: state.item)
            timer.startTimer(for: state.item)
            timer.resume()
        } catch {
            state.error = error
        }
    }
    
    func endSession() {
        #warning("Notify DeviceActivityRegistrar of stopping and unregistering the session")
    }
    
}

extension TaskConcentrationViewModel: FTTimerDelegate {
    func didUpdateIsPaused(_ pause: Bool) { }
    
    func didFinishCountdown() {
        timer.cancel()
        moveTo(.finished)
    }
}
