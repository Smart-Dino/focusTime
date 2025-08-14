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
    private let modelContainer: ModelContainer
    
    // Prepare for future async fetching tasks.
    private var fetchTask: Task<Void, Never>? = nil
    
    // MARK: - Initializer
    init(
        state: State = State(),
        center: DeviceActivityCenter = DeviceActivityCenter(),
        shieldManager: ShieldManager = LiveShieldManager(),
        modelContainer: ModelContainer,
    ) {
        self.state = state
        self.shieldManager = shieldManager
        self.modelContainer = modelContainer
        self.activityRegistrar = LiveDeviceActivityRegistrar(modelContainer: modelContainer, shieldManager: shieldManager)
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
    func eraseAllData() {
        Task.detached(priority: .userInitiated) {
            do {
                let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
                try await blockItemStore.eraseAllData()
                await self.fetchAllItems()
                await self.activityRegistrar.unregisterAll()
            } catch {
                await MainActor.run {
                    self.state.error = error
                }
            }
        }
    }
    
    func addScheduleToDB() {
        let protectedSelection = ProtectedActivitySelection(state.selection)
        let state = self.state
        Task.detached(priority: .userInitiated) {
            do {
                let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
                let blockItems = try await blockItemStore.fetch()
                
                // Ensure we only add if the store is empty.
                if !blockItems.isEmpty {
                    try await blockItemStore.eraseAllData()
                }
                
                var type: ScheduleType!
                
                switch state.scheduleType {
                case .duration:
                    type = .duration(DurationComponents(duration: state.duration * 60)) // Minutes to seconds.
                case .scheduled:
                    let startComponent = try TimeComponents(from: state.startTime)
                    let endComponent = try TimeComponents(from: state.endTime)
                        
                    type = .scheduled(startTime: startComponent, endTime: endComponent)
                }
                
                let blockItem = await ProtectedBlockItem(emoji: "❌",
                                                   name: "Block",
                                                    days: self.state.daySelection,
                                                   type: type,
                                                   blockedContent: protectedSelection)
                
                
                    try await blockItemStore.insert(blockItem)
                
                await self.fetchAllItems()
            } catch {
                await MainActor.run {
                    self.state.error = error
                }
            }
        }
    }
    
    func fetchAllItems() {
        Task.detached(priority: .userInitiated) {
            do {
                let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
                let fetchedBlockItems = try await blockItemStore.fetch()
                await MainActor.run {
                    self.state.blockItems = fetchedBlockItems
                }
            } catch {
                await MainActor.run {
                    self.state.error = error
                }
            }
        }
    }
    
    func blockSelectionDuringSchedule() {
        Task.detached(priority: .userInitiated) {
            do {
                let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
                guard let blockItem = try await blockItemStore.fetch(descriptor: .init()).first else {
                    return
                }
                
                try await self.activityRegistrar.registerActivity(during: blockItem)
            } catch {
                await MainActor.run {
                    self.state.error = error
                }
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
        Task.detached(priority: .userInitiated) { [self] in
            do {
                let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
                let blockItems = try await blockItemStore.fetch()
                
                guard let blockItem = blockItems.first else { return }
                
                try await activityRegistrar.suspendActivity(for: blockItem)
            } catch {
                await MainActor.run {
                    self.state.error = error
                }
            }
        }
    }
    
    func resumeSession() {
        Task.detached(priority: .userInitiated) { [self] in
            do {
                let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
                let blockItems = try await blockItemStore.fetch()
                guard let blockItem = blockItems.first else { return }
                try await activityRegistrar.resumeActivity(for: blockItem)
            } catch {
                await MainActor.run {
                    self.state.error = error
                }
            }
        }
    }
    
}

