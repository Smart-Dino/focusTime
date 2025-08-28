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
    @MainActor
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
        
        let timer: FTTimer
        var timerPayload: FTTimerPayload {
            timer.payload
        }
        
        var error: Error?
        
        var item: ProtectedBlockItem
        var phase: Phase
    }
    
    // MARK: - Properties
    private(set) var state: State
    
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    
    private var dbChangesNotificationTask: Task<Void, Never>?
    
    // MARK: - Initialization
    init(
        state: State,
        deviceActivityRegistrar: DeviceActivityRegistrar,
        blockItemPersistenceManager: BlockItemPersistenceManager
    ) {
        self.state = state
        self.deviceActivityRegistrar = deviceActivityRegistrar
        self.blockItemPersistenceManager = blockItemPersistenceManager
        
        subscribeToDB()
    }
    
    // MARK: - Public Methods
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
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
    
    func moveToBreakTimeAndSetupBreakTimer() {
        moveTo(.breakTime)
        state.timer.start(
            deadline: .now.addingTimeInterval(TimeInterval(SharedAppValues.breakTimeDuration)),
            isInitiallyPaused: true
        )
    }
    
    func moveToEndSessionAlertScene() {
        moveTo(.almostDone)
    }
    
    func endBlock() async throws {
        do {
            try await deviceActivityRegistrar.cancelIfRunning(state.item)
            state.timer.cancel()
        } catch {
            state.error = error
            throw error // Rethrow so the view does not dismiss.
        }
    }
    
    // MARK: - Private Methods
    
    private func moveTo(_ phase: State.Phase) {
        guard state.phase != phase else {
            return
        }
        
        withAnimation {
            state.phase = phase
        }
    }
    
    private func subscribeToDB() {
        dbChangesNotificationTask = Task {
            for await _ in await blockItemPersistenceManager.contextChangesStream() {
                try? await Task.sleep(for: SharedAppValues.debounceAfterDBRefreshed)
                
                guard let newItem = try? await blockItemPersistenceManager.fetchClosestOrRunningCurrentScheduled(now: .now),
                      newItem.state.isActive else {
                    moveTo(.finished)
                    return
                }
                
                updateStateWithNewItem(newItem)
            }
        }
    }
    
    private func updateStateWithNewItem(_ newItem: ProtectedBlockItem) {
        if newItem.state == .running {
            moveTo(.focus)
        }
        
        state.item = newItem
        state.timer.startTimer(for: newItem, withSuspensionCountdown: true)
        state.timer.resume()
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
