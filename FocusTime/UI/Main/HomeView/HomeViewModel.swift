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
    private var pauseResumeTask: Task<Void, Never>?
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
    
    func subscribeToDB() {
        dbChangesNotificationTask = Task {
            for await _ in await blockItemPersistenceManager.contextChangesStream() {
                try? await Task.sleep(for: SharedAppValues.debounceAfterDBRefreshed)
                setUpcomingItem()
            }
        }
    }
    
    func setTimerIsPaused(_ pause: Bool) {
        // Cancel any previously running pause/resume task
        pauseResumeTask?.cancel()
        
        pauseResumeTask = Task { [weak self] in
            guard let item = self?.state.upcomingOrRunningItem else { return }
            
            do {
                if pause {
                    try await self?.pause(item)
                } else {
                    try await self?.resume(item)
                }
            } catch is CancellationError {
                // Task was cancelled, safe to ignore.
            } catch {
                self?.state.error = error
            }
        }
    }

    private func pause(_ item: ProtectedBlockItem) async throws {
        timer.pause()
        try Task.checkCancellation()
        try await deviceActivityRegistrar.suspendActivity(for: item)
    }

    private func resume(_ item: ProtectedBlockItem) async throws {
        try await deviceActivityRegistrar.resumeActivity(for: item)
        try Task.checkCancellation()
        timer.startTimer(for: item)
        timer.resume()
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
