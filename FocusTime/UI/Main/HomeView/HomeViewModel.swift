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
    case focusSession(_ viewModel: FocusSessionViewModel)
    
    var id: Self { self }
    
    static func == (lhs: HomeViewNavigationRoute, rhs: HomeViewNavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case let (.scheduledFocusList(lVM), .scheduledFocusList(rVM)):
            lVM === rVM
        case let (.taskConcentration(lVM), .taskConcentration(rVM)):
            lVM === rVM
        case let (.focusSession(lVM), .focusSession(rVM)):
            lVM === rVM
        default:
            false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .scheduledFocusList(vm):
            hasher.combine(0)
            hasher.combine(ObjectIdentifier(vm))
        case let .taskConcentration(vm):
            hasher.combine(1)
            hasher.combine(ObjectIdentifier(vm))
        case let .focusSession(vm):
            hasher.combine(2)
            hasher.combine(ObjectIdentifier(vm))
        }
    }
}

@MainActor
@Observable
final class HomeViewModel {
    @MainActor
    struct State {
        let timer: FTTimer
        var timerPayload: FTTimerPayload {
            timer.payload
        }
        
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
    
    private(set) var state: State
    
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    weak var delegate: HomeViewDelegate?
    
    private var fetchTask: Task<Void, Never>?
    private var dbChangesNotificationTask: Task<Void, Never>?
    
    init(
        state: State,
        deviceActivityRegistrar: DeviceActivityRegistrar,
        blockItemPersistenceManager: BlockItemPersistenceManager,
        delegate: HomeViewDelegate?
    ) {
        self.state = state
        self.deviceActivityRegistrar = deviceActivityRegistrar
        self.blockItemPersistenceManager = blockItemPersistenceManager
        self.delegate = delegate
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func subscribeToDB() {
        dbChangesNotificationTask = Task {
            for await _ in await blockItemPersistenceManager.contextChangesStream() {
                try? await Task.sleep(for: SharedAppValues.debounceAfterDBRefreshed)
                setUpcomingItem()
            }
        }
    }
    
    func checkAuthorization() {
        Task {
            do {
                try await deviceActivityRegistrar.checkAuth()
            } catch {
                state.error = error
            }
        }
    }
    
    func setUpcomingItem() {
        guard fetchTask == nil else { return }
        fetchTask = Task {
            do {
                state.upcomingOrRunningItem = try await blockItemPersistenceManager.fetchClosestOrRunningCurrentScheduled(now: .now)
                setupTimerForActiveItem()
            } catch {
                state.error = error
            }
            fetchTask = nil
        }
    }
    
    private func setupTimerForActiveItem() {
        if let activeItem = state.upcomingOrRunningItem, activeItem.state.isActive {
            state.timer.startTimer(for: activeItem, withSuspensionCountdown: true)
         }
     }
    
    func setNextNavigationScreen(_ showing: Bool) {
        if !showing {
            state.nextNavigationScreen = nil
        }
    }
    
    func showFocusSessionSetupView() {
        state.nextNavigationScreen = .focusSession(
            makeFocusSessionViewModel(mode: .startFocusing)
        )
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
    
    private func makeFocusSessionViewModel(mode: FocusSessionMode) -> FocusSessionViewModel {
        FocusSessionViewModel(
            mode: mode,
            blockItemPersistenceManager: blockItemPersistenceManager,
            deviceActivityRegistrar: deviceActivityRegistrar
        )
    }
    
    private func makeTaskConcentrationViewModel(with phase: TaskConcentrationViewModel.State.Phase) -> TaskConcentrationViewModel? {
        guard let upcomingOrRunningItem = state.upcomingOrRunningItem else { return nil }
        
        return TaskConcentrationViewModel(
            state: .init(timer: state.timer, item: upcomingOrRunningItem, phase: phase),
            deviceActivityRegistrar: deviceActivityRegistrar,
            blockItemPersistenceManager: blockItemPersistenceManager
        )
    }
}
