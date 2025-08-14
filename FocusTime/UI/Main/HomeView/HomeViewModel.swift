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
    
    var id: Self { self }
    
    static func == (lhs: HomeViewNavigationRoute, rhs: HomeViewNavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case (.scheduledFocusList, .scheduledFocusList): true
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .scheduledFocusList:
            hasher.combine(0)
        }
    }
}

@MainActor
@Observable
final class HomeViewModel {
    struct State {
        var error: Error? = nil
        
        var upcomingOrRunningItem: ProtectedBlockItem?
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
    
    func setTimerIsPaused(_ pause: Bool) {
        if pause {
            timer.pause()
        } else {
            if let upcomingOrRunningItem = state.upcomingOrRunningItem {
                // Since duration blocking updates it's deadline after resumption we need to recreate the timer.
                timer.startTimer(for: upcomingOrRunningItem)
                timer.resume()
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
    
    private func makeScheduledFocusViewModel() -> ScheduledBlockItemsViewModel {
        ScheduledBlockItemsViewModel(blockItemPersistenceManager: blockItemPersistenceManager)
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
