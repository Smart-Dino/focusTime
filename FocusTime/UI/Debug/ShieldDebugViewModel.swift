//
//  ShieldDebugViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 24.06.2025.
//

import SwiftData
import Foundation
import FamilyControls
import DeviceActivity

@MainActor
@Observable
final class ShieldDebugViewModel {
    // MARK: - Nested declarations
    @MainActor
    struct State {
        enum ScheduleType {
            case scheduled
            case duration
            
            var buttonTitle: String {
                switch self {
                case .scheduled:
                    "Activate scheduled block"
                case .duration:
                    "Start duration block"
                }
            }
        }
        
        var error: Error? = nil
        
        var selection: FamilyActivitySelection = .init()
        var daySelection: Set<Weekday> = Set(Weekday.allCases)
        
        var scheduleType: Self.ScheduleType = .scheduled
        var startTime: Date = .now
        var endTime: Date = .now
        var duration: Int = 1 // Minutes
        
        var blockItems: [ProtectedBlockItem] = .init()
        
        var isAppSelectionPresented = false
    }
    
    // MARK: - Properties
    private(set) var state: State
    // Shield-related.
    private let shieldManager: ShieldManager
    private let activityRegistrar: DeviceActivityRegistrar
    // Model-related.
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    
    // Prepare for future async fetching tasks.
    private var fetchTask: Task<Void, Never>? = nil
    private var dbChangesNotificationTask: Task<Void, Never>?
    
    // MARK: - Initializer
    init(
        state: State = State(),
        center: DeviceActivityCenter = DeviceActivityCenter(),
        shieldManager: ShieldManager = LiveShieldManager(),
        blockItemPersistenceManager: BlockItemPersistenceManager,
    ) {
        self.state = state
        self.shieldManager = shieldManager
        self.blockItemPersistenceManager = blockItemPersistenceManager
        self.activityRegistrar = LiveDeviceActivityRegistrar(
            blockItemPersistenceManager: blockItemPersistenceManager,
            shieldManager: shieldManager
        )
        
        subscribeToDB()
    }
    
    func subscribeToDB() {
        dbChangesNotificationTask = Task {
            for await _ in await blockItemPersistenceManager.contextChangesStream() {
                try? await Task.sleep(for: SharedAppValues.debounceAfterDBRefreshed)
                reloadItems()
            }
        }
    }
    
    // MARK: - Setters
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func setStartTime(_ date: Date) {
        state.startTime = date
    }
    
    func setEndTime(_ date: Date) {
        state.endTime = date
    }
    
    func setAppSelectionPresented(_ isPresented: Bool) {
        state.isAppSelectionPresented = isPresented
    }
    
    func setSelection(_ selection: FamilyActivitySelection) {
        state.selection = selection
    }
    
    func setScheduleType(_ type: State.ScheduleType) {
        state.scheduleType = type
    }
    
    func setDuration(_ duration: Int) {
        state.duration = duration
    }
    
    func toggleSelectionFor(weekday: Weekday) {
        if state.daySelection.contains(weekday) {
            state.daySelection.remove(weekday)
        } else {
            state.daySelection.insert(weekday)
        }
    }
    
    // MARK: - Methods
    func eraseAllData() {
        Task {
            do {
                try await blockItemPersistenceManager.eraseAllData()
                await self.activityRegistrar.unregisterAll()
            } catch {
                self.state.error = error
            }
        }
    }
    
    func addScheduleToDB() {
        let protectedSelection = ProtectedActivitySelection(state.selection)
        let state = self.state
        Task {
            do {
                let blockItems = try await self.blockItemPersistenceManager.fetch(includeTemporary: true)
                
                // Ensure we only add if the store is empty.
                if !blockItems.isEmpty {
                    try await self.blockItemPersistenceManager.eraseAllData()
                }
                
                var type: ScheduleType!
                
                switch state.scheduleType {
                case .duration:
                    type = .duration(duration: DurationComponents(seconds: state.duration * 60)) // Minutes to seconds.
                case .scheduled:
                    let startComponent = try TimeComponents(from: state.startTime)
                    let endComponent = try TimeComponents(from: state.endTime)
                        
                    type = .scheduled(startTime: startComponent, endTime: endComponent)
                }
                
                let blockItem = ProtectedBlockItem(emoji: "❌",
                                                   name: "Block",
                                                    days: state.daySelection,
                                                   type: type,
                                                   blockedContent: protectedSelection)
                
                
                try await self.blockItemPersistenceManager.insert(blockItem)
            } catch {
                await MainActor.run {
                    self.state.error = error
                }
            }
        }
    }
    
    func reloadItems() {
        fetchTask?.cancel()
        fetchTask = Task {
            do {
                let newItems = try await blockItemPersistenceManager.fetch(includeTemporary: true)
                state.blockItems = newItems
            } catch {
                state.error = error
            }
            fetchTask = nil
        }
    }
    
    func blockSelectionDuringSchedule() {
        Task {
            do {
                guard let blockItem = try await self.blockItemPersistenceManager.fetch(includeTemporary: true).first else {
                    return
                }
                
                try await self.activityRegistrar.registerActivity(during: blockItem)
            } catch {
                self.state.error = error
            }
        }
    }
    
    func blockSelection() async {
        do {
            try await shieldManager.block(specific: ProtectedActivitySelection(state.selection))
        } catch {
            state.error = error
        }
    }
    
    func unblockSelection() async {
        do {
            try await shieldManager.unblock()
        } catch {
            state.error = error
        }
    }
    
    func toggleSelectionSheet() async {
        do {
            try await shieldManager.checkAuthorization()
            state.isAppSelectionPresented.toggle()
        } catch {
            state.error = error
        }
    }
    
    func suspendSession() {
        Task {
            do {
                let blockItems = try await self.blockItemPersistenceManager.fetch(includeTemporary: true)
                
                guard let blockItem = blockItems.first else { return }
                
                try await activityRegistrar.suspendActivity(for: blockItem)
            } catch {
                self.state.error = error
            }
        }
    }
    
    func resumeSession() {
        Task {
            do {
                let blockItems = try await self.blockItemPersistenceManager.fetch(includeTemporary: true)
                guard let blockItem = blockItems.first else { return }
                try await activityRegistrar.resumeActivity(for: blockItem)
            } catch {
                self.state.error = error
            }
        }
    }
    
    func suspendFor(_ seconds: Int = 60) {
        Task {
            do {
                let blockItems = try await self.blockItemPersistenceManager.fetch(includeTemporary: true)
                guard let blockItem = blockItems.first else { return }
                try await activityRegistrar.suspendActivity(for: blockItem, forSeconds: seconds)
            } catch {
                self.state.error = error
            }
        }
    }
    
}

