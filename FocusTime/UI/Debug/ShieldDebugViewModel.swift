//
//  ShieldDebugViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 24.06.2025.
//

import SwiftData
import Foundation
import FamilyControls

@MainActor
@Observable
final class ShieldDebugViewModel {
    // MARK: - Nested declarations
    @MainActor
    struct State {
        enum ScheduleType {
            case scheduled
            case oneTime
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
    private let blockItemStore: BlockItemStore
    
    // Prepare for future async fetching tasks.
    private var fetchTask: Task<Void, Never>? = nil
    
    // MARK: - Initializer
    init(
        state: State = State(),
        shieldManager: ShieldManager = LiveShieldManager(),
        modelContainer: ModelContainer,
    ) {
        self.state = state
        self.shieldManager = shieldManager
        self.blockItemStore = BlockItemStore(modelContainer: modelContainer)
        self.activityRegistrar = LiveDeviceActivityRegistrar(blockItemStore: blockItemStore, shieldManager: shieldManager)
        
        Task {
            await activityRegistrar.unregisterAll()
        }
    }
    
    // MARK: - Setters
    func removeError(_ removeError: Bool) {
        if removeError {
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
    func eraseAllData() async {
        do {
            try await blockItemStore.eraseAllData()
            await activityRegistrar.unregisterAll()
            await fetchAllItems()
        } catch {
            state.error = error
        }
    }
    
    func addScheduleToDB() async {
        do {
            let blockItems = try await blockItemStore.fetch()
            
            // Ensure we only add if both stores are empty
            guard blockItems.isEmpty else { return }
            
            var type: ScheduleType!
            
            switch state.scheduleType {
            case .oneTime:
                type = .oneTime(DurationComponents(duration: state.duration * 60)) // Minutes to seconds.
            case .scheduled:
                guard let startComponent = TimeComponents(from: state.startTime),
                      let endComponent = TimeComponents(from: state.endTime) else {
                    state.error = ShieldDebugError.timeComponent
                    return
                }
                type = .scheduled(startTime: startComponent, endTime: endComponent)
            }
            
            let blockItem = ProtectedBlockItem(emoji: "❌",
                                               name: "Block",
                                               days: state.daySelection,
                                               type: type,
                                               blockedContent: ProtectedActivitySelection(state.selection))
            
            
            do {
                try await blockItemStore.insert(blockItem)
            } catch {
                state.error = error
            }
            
            await fetchAllItems()
        } catch {
            state.error = error
        }
    }
    
    func fetchAllItems() async {
        do {
            state.blockItems = try await blockItemStore.fetch()
        } catch {
            state.error = error
        }
    }
    
    func blockSelectionDuringSchedule() async {
        do {
            guard let blockItem = try await blockItemStore.fetch(descriptor: .init()).first else {
                return
            }
            
            try await activityRegistrar.registerActivity(during: blockItem)
        } catch {
            state.error = error
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
    
    func suspendSession() async {
        do {
            let blockItems = try await blockItemStore.fetch()
            guard let blockItem = blockItems.first else { return }
            try await activityRegistrar.suspendActivity(for: blockItem)
        } catch {
            state.error = error
        }
    }
    
    func resumeSession() async {
        do {
            let blockItems = try await blockItemStore.fetch()
            guard let blockItem = blockItems.first else { return }
            try await activityRegistrar.resumeActivity(for: blockItem)
        } catch {
            state.error = error
        }
    }
    
}

