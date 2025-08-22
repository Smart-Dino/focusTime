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
                runningIcon: String
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
        var phase: Phase
        
        var timerIsPaused: Bool = true
    }
    
    // MARK: - Properties
    private(set) var state: State
    let timer: FTTimer
    
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    
    private var dbChangesNotificationTask: Task<Void, Never>?
    
    // MARK: - Initialization
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
        
        setupTimer()
        subscribeToDB()
    }
    
    // MARK: - Public Methods
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
    
    func startBreakTimer() {
        Task {
            await startABreak()
        }
    }
    
    func moveToPauseSessionScene() {
        moveTo(.breakTransition)
    }
    
    func moveToBreakTime() {
        moveTo(.breakTime)
    }
    
    func moveToEndSessionAlertScene() {
        moveTo(.almostDone)
    }
    
    func replaceTimerWithSuspensionTimer() {
        timer.start(
            deadline: .now.addingTimeInterval(TimeInterval(SharedAppValues.breakTimeDuration)),
            isInitiallyPaused: true
        )
    }
    
    func endBlock() async throws {
        do {
            try await deviceActivityRegistrar.cancelIfRunning(state.item)
            timer.cancel()
        } catch {
            state.error = error
            throw error // Rethrow so the view does not dismiss.
        }
    }
    
    // MARK: - Private Methods
    private func setupTimer() {
        timer.delegate = self
        state.timerIsPaused = timer.isPaused
    }
    
    private func moveTo(_ phase: State.Phase) {
        guard state.phase != phase else { return }
        
        withAnimation {
            state.phase = phase
        }
    }
    
    private func subscribeToDB() {
        dbChangesNotificationTask = Task {
            for await _ in await blockItemPersistenceManager.contextChangesStream() {
                try? await Task.sleep(for: SharedAppValues.debounceAfterDBRefreshed)
                
                guard let newItem = try? await blockItemPersistenceManager.fetchClosestOrRunningCurrentScheduled(now: .now) else {
                    moveTo(.finished)
                    return
                }
                
                updateStateWithNewItem(newItem)
            }
        }
    }
    
    private func updateStateWithNewItem(_ newItem: ProtectedBlockItem) {
        state.item = newItem
        timer.startTimer(for: newItem)
        timer.resume()
        
        if state.item.state == .running {
            moveTo(.focus)
        }
    }
    
    private func startABreak(for seconds: Int = SharedAppValues.breakTimeDuration) async {
        do {
            try await deviceActivityRegistrar.suspendActivity(for: state.item, forSeconds: seconds)
        } catch {
            state.error = error
        }
    }
    
    private func resumeFromBreak() async {
        do {
            try await deviceActivityRegistrar.resumeActivity(for: state.item)
        } catch {
            state.error = error
        }
    }
}

// MARK: - FTTimerDelegate
extension TaskConcentrationViewModel: FTTimerDelegate {
    
    func didUpdateIsPaused(_ pause: Bool) {
        // Implementation pending
    }
    
    func didFinishCountdown() {
        timer.cancel()
    }
}
