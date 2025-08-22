//
//  HomeViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.06.2025.
//

import SwiftUI
import SwiftData
import FocusTimeUI

enum HomeViewNavigationRoute: Equatable, Hashable {
    case scheduledFocusList(_ viewModel: ScheduledBlockItemsViewModel)
    case taskConcentration(_ viewModel: TaskConcentrationViewModel)
    
    var id: Self { self }
    
    static func == (lhs: HomeViewNavigationRoute, rhs: HomeViewNavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case (.scheduledFocusList, .scheduledFocusList): true
        case (.taskConcentration, .taskConcentration): true
        default: false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .scheduledFocusList:
            hasher.combine(0)
        case .taskConcentration:
            hasher.combine(1)
        }
    }
}

@MainActor
@Observable
final class HomeViewModel {
    struct State {
        var error: Error? = nil
        
        var upcomingOrRunningItem: ProtectedBlockItem?
        var isPaused: Bool {
            guard let upcomingOrRunningItem else { return true }
            
            if upcomingOrRunningItem.state == .running {
                return false
            } else {
                return true
            }
        }
        
        var nextNavigationScreen: HomeViewNavigationRoute?
    }
    
    let timer: FTTimer
    private(set) var state: State
    
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    weak var delegate: HomeViewDelegate?
    
    private var fetchTask: Task<Void, Never>?
    private var dbChangesNotificationTask: Task<Void, Never>?
    
    init(
        state: State = State(),
        timer: FTTimer,
        deviceActivityRegistrar: DeviceActivityRegistrar,
        blockItemPersistenceManager: BlockItemPersistenceManager,
        delegate: HomeViewDelegate?
    ) {
        self.state = state
        self.timer = timer
        self.deviceActivityRegistrar = deviceActivityRegistrar
        self.blockItemPersistenceManager = blockItemPersistenceManager
        self.delegate = delegate
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func injectDelegateToTimer() {
        timer.delegate = self
    }
    
    func subscribeToDB() {
        dbChangesNotificationTask = Task {
            for await _ in await blockItemPersistenceManager.contextChangesStream() {
                try? await Task.sleep(for: SharedAppValues.debounceAfterDBRefreshed)
                setUpcomingItem()
            }
        }
    }
    
    func startTimer(for blockItem: ProtectedBlockItem) {
        timer.startTimer(for: blockItem)
    }
    
    func setUpcomingItem() {
        guard fetchTask == nil else { return }
        fetchTask = Task {
            do {
                state.upcomingOrRunningItem = try await blockItemPersistenceManager.fetchClosestOrRunningCurrentScheduled(now: .now)
                if let item = state.upcomingOrRunningItem {
                    startTimer(for: item)
                }
            } catch {
                state.error = error
            }
            fetchTask = nil
        }
    }
    
    func setNextNavigationScreen(_ showing: Bool) {
        if !showing {
            state.nextNavigationScreen = nil
        }
    }
    
    func showScheduledFocusView() {
        state.nextNavigationScreen = .scheduledFocusList(makeScheduledFocusViewModel())
    }
    
    func showTaskConcentrationView(isPauseAction: Bool) {
        if state.isPaused {
            if let viewModel = makeTaskConcentrationViewModel(with: .breakTime) {
                state.nextNavigationScreen = .taskConcentration(viewModel)
                return
            }
        }
            
            if isPauseAction {
                if let viewModel = makeTaskConcentrationViewModel(with: .breakTransition) {
                    state.nextNavigationScreen = .taskConcentration(viewModel)
                }
            } else {
                if let viewModel = makeTaskConcentrationViewModel(with: .focus) {
                    state.nextNavigationScreen = .taskConcentration(viewModel)
                }
            }
    }
    
    private func makeScheduledFocusViewModel() -> ScheduledBlockItemsViewModel {
        ScheduledBlockItemsViewModel(blockItemPersistenceManager: blockItemPersistenceManager)
    }
    
    private func makeTaskConcentrationViewModel(with phase: TaskConcentrationViewModel.State.Phase) -> TaskConcentrationViewModel? {
        guard let upcomingOrRunningItem = state.upcomingOrRunningItem else { return nil }
        
        return TaskConcentrationViewModel(
            state: .init(item: upcomingOrRunningItem, phase: phase),
            timer: timer,
            deviceActivityRegistrar: deviceActivityRegistrar,
            blockItemPersistenceManager: blockItemPersistenceManager
        )
    }
}

extension HomeViewModel: FTTimerDelegate {
    func didUpdateIsPaused(_ pause: Bool) {
        guard let item = state.upcomingOrRunningItem else { return }
        
        Task {
            do {
                pause
                ? try await deviceActivityRegistrar.suspendActivity(for: item)
                : try await deviceActivityRegistrar.resumeActivity(for: item)
            } catch {
                state.error = error
            }
        }
    }
    
    func didFinishCountdown() {
        timer.cancel()
    }
}
