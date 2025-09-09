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
        
        var shouldDismiss = false
        
        var item: ProtectedBlockItem
        var phase: Phase
    }
    
    // MARK: - Properties
    private(set) var state: State
    
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    
    private var dbChangesNotificationTask: Task<Void, Never>?
    
    private var analyticsManager: AnalyticsManagerProtocol
    
    // MARK: - Initialization
    init(
        state: State,
        deviceActivityRegistrar: DeviceActivityRegistrar,
        blockItemPersistenceManager: BlockItemPersistenceManager,
        analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()
    ) {
        self.state = state
        self.deviceActivityRegistrar = deviceActivityRegistrar
        self.blockItemPersistenceManager = blockItemPersistenceManager
        self.analyticsManager = analyticsManager
        
        subscribeToDB()
    }
    
    // MARK: - Public Methods
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
        
        /// - Analytics
        analyticsManager.logEvent(name: AnalyticsEventsConstants.TaskConcentrationViewAnalyticsConstants.AnalyticsEvents.taskConcentrationErrorVisibilityChanged.rawValue, parameters: [AnalyticsEventsConstants.TaskConcentrationViewAnalyticsConstants.AnalyticsEventsParameters.isVisible.rawValue: isVisible])
    }
    
    func startBreakTimer() {
        /// - Analytics
        analyticsManager.logEvent(name: AnalyticsEventsConstants.TaskConcentrationViewAnalyticsConstants.AnalyticsEvents.taskConcentrationStartBreakTimer.rawValue, parameters: nil)
        
        Task {
            await startABreak()
        }
    }
    
    func moveToPauseSessionScene() {
        /// - Analytics
        analyticsManager.logEvent(name: AnalyticsEventsConstants.TaskConcentrationViewAnalyticsConstants.AnalyticsEvents.taskConcentrationMoveToPauseScene.rawValue, parameters: nil)
        
        moveTo(.breakTransition)
    }
    
    func moveToBreakTimeAndSetupBreakTimer() {
        /// - Analytics
        analyticsManager.logEvent(name: AnalyticsEventsConstants.TaskConcentrationViewAnalyticsConstants.AnalyticsEvents.taskConcentrationMoveToBreakTimeAndSetupTimer.rawValue, parameters: nil)
        
        moveTo(.breakTime)
        state.timer.start(
            deadline: .now.addingTimeInterval(TimeInterval(SharedAppValues.breakTimeDuration)),
            isInitiallyPaused: true
        )
    }
    
    func moveToEndSessionAlertScene() {
        /// - Analytics
        analyticsManager.logEvent(name: AnalyticsEventsConstants.TaskConcentrationViewAnalyticsConstants.AnalyticsEvents.taskConcentrationMoveToEndSessionAlert.rawValue, parameters: nil)
        
        moveTo(.almostDone)
    }
    
    func dismiss() {
        state.shouldDismiss = true
        /// - Analytics
        analyticsManager.logEvent(name: AnalyticsEventsConstants.TaskConcentrationViewAnalyticsConstants.AnalyticsEvents.taskConcentrationDismissed.rawValue, parameters: nil)
    }
    
    func endBlock() {
        /// - Analytics
        analyticsManager.logEvent(name: AnalyticsEventsConstants.TaskConcentrationViewAnalyticsConstants.AnalyticsEvents.taskConcentrationEndBlock.rawValue, parameters: nil)
        
        Task {
            do {
                try await deviceActivityRegistrar.cancelIfRunning(state.item)
                state.timer.cancel()
                dismiss()
            } catch {
                state.error = error
            }
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
            if state.item.state == .running {
                moveTo(.focus)
            }
            state.timer.startTimer(for: state.item, withSuspensionCountdown: true)
        }
    }
}
