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
        
        var schedules: [ProtectedSchedule] = .init()
        var blockItems: [ProtectedBlockItem] = .init()
        
        var isAppSelectionPresented = false
    }
    
    // MARK: - Properties
    private(set) var state: State
    // Shield-related.
    private let shieldManager: ShieldManager
    private let activityRegistrar: DeviceActivityRegistrar
    // Model-related.
    private let scheduleStore: ScheduleStore
    private let blockItemStore: BlockItemStore
    private let relationshipCoordinator: RelationshipCoordinator
    
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
        self.activityRegistrar = LiveDeviceActivityRegistrar(modelContainer: modelContainer, shieldManager: shieldManager)
        self.scheduleStore = ScheduleStore(modelContainer: modelContainer)
        self.blockItemStore = BlockItemStore(modelContainer: modelContainer)
        self.relationshipCoordinator = RelationshipCoordinator(modelContainer: modelContainer)
        
        activityRegistrar.unregisterAll()
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
            try await scheduleStore.eraseAllData()
            await fetchAllItems()
        } catch {
            state.error = error
        }
    }
    
    func addScheduleToDB() async {
        do {
            let blockItems = try await blockItemStore.fetch()
            let scheduleItems = try await scheduleStore.fetch()
            
            // Ensure we only add if both stores are empty
            guard blockItems.isEmpty && scheduleItems.isEmpty else { return }
            
            let blockItem = ProtectedBlockItem(emoji: "❌", name: "Block",
                                               blockedContent: ProtectedActivitySelection(state.selection))
            
            var type: ScheduleType!
            
            switch state.scheduleType {
            case .oneTime:
                type = .oneTime(duration: state.duration * 60) // Minutes to seconds.
            case .scheduled:
                guard let startComponent = TimeComponents(from: state.startTime),
                      let endComponent = TimeComponents(from: state.endTime) else {
                    state.error = ShieldDebugError.timeComponent
                    return
                }
                type = .scheduled(startTime: startComponent, endTime: endComponent)
            }
            
            let schedule = ProtectedSchedule(emoji: "🕑",
                                             name: "Schedule",
                                             days: state.daySelection,
                                             type: type)
            
            do {
                try await blockItemStore.insert(blockItem)
                try await scheduleStore.insert(schedule)
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
            state.schedules = try await scheduleStore.fetch()
            state.blockItems = try await blockItemStore.fetch()
        } catch {
            state.error = error
        }
    }
    
    func appendBlockItemToSchedule() async {
        do {
            guard let blockItem = try await blockItemStore.fetch(descriptor: .init()).first else {
                return
            }
            guard let schedule = try await scheduleStore.fetch(descriptor: .init()).first else {
                return
            }
            
            guard let blockItemModelID = blockItem.persistentModelID,
                  let schedulesModelID = schedule.persistentModelID
            else {
                throw ShieldDebugError.invalidPersistentIdentifiers
            }
            
            try await relationshipCoordinator.relate(blockItemID: blockItemModelID,
                                                     scheduleID: schedulesModelID)
            
            await fetchAllItems()
        } catch {
            state.error = error
        }
    }
    
    func blockSelectionDuringSchedule() async {
        do {
            guard let schedule = try await scheduleStore.fetch(descriptor: .init()).first else {
                return
            }
            
            try await activityRegistrar.registerActivity(during: schedule)
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
}

