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
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func setUpcomingItem() async {
        do {
            if let newItem = try await blockItemPersistenceManager.fetchClosestOrRunningCurrentScheduled(now: .now) {
                state.item = newItem
            }
        } catch {
            state.error = error
        }
    }
    
    func toggleTimerIsPaused() {
        Task {
            try await Task.sleep(for: .seconds(1))
            if timer.isPaused {
                await resumeFromBreak()
                moveTo(.focus)
            } else {
                timer.start(
                    deadline: .now.addingTimeInterval(TimeInterval(SharedAppValues.breakTimeDuration)),
                    isInitiallyPaused: true
                )
                moveTo(.breakTransition)
            }
        }
    }
    
    func moveTo(_ phase: State.Phase) {
        withAnimation {
            state.phase = phase
        }
    }
    
    func startTimerPauseTimer() {
        Task {
            await startABreak()
        }
    }
    
    func startABreak(for seconds: Int = SharedAppValues.breakTimeDuration) async {
        do {
            try await deviceActivityRegistrar.suspendActivity(for: state.item, forSeconds: seconds)
            await setUpcomingItem()
            timer.startTimer(for: state.item)
            timer.resume()
        } catch {
            state.error = error
        }
    }
    
    func resumeFromBreak() async {
        do {
            // Since duration blocking updates it's deadline after resumption we need to recreate the timer.
            try await deviceActivityRegistrar.cancelScheduledResume(for: state.item)
            await setUpcomingItem()
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
