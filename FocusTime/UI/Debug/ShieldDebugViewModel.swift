//
//  ShieldDebugViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 24.06.2025.
//

import Foundation
import FamilyControls

extension FamilyActivitySelection: @unchecked @retroactive Sendable {}

@MainActor
@Observable
final class ShieldDebugViewModel {
    // MARK: - Nested declarations
    @MainActor
    struct State {
        var error: Error? = nil
        
        var selection: FamilyActivitySelection = .init()
        var daySelection: Set<Weekday> = .init()
        
        var startTime: Date = .now
        var endTime: Date = .now
        
        var schedules: [Schedule] = .init()
        var blockItems: [BlockItem] = .init()
        
        var isAppSelectionPresented = false
    }
    
    // MARK: - Properties
    private(set) var state: State
    let shieldManager: ShieldManager
    private let scheduleStore: ScheduleStore
    private let blockItemStore: BlockItemStore
    
    // MARK: - Initializer
    init(
        state: State = State(),
        shieldManager: ShieldManager = LiveShieldManager(),
        scheduleStore: ScheduleStore = ScheduleStore(),
        blockItemStore: BlockItemStore = BlockItemStore()
        
    ) {
        self.state = state
        self.shieldManager = shieldManager
        self.scheduleStore = scheduleStore
        self.blockItemStore = blockItemStore
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
    
    func toggleSelectionFor(weekday: Weekday) {
        if state.daySelection.contains(weekday) {
            state.daySelection.remove(weekday)
        } else {
            state.daySelection.insert(weekday)
        }
    }
    
    #warning("Code methods to reset app state instead of reinstalling it each time")
    // MARK: - Methods
    func eraseAllData() {
        do {
            try blockItemStore.eraseAllData()
            try scheduleStore.eraseAllData()
            fetchAllItems()
        } catch {
            state.error = error
        }
    }
    
    func addScheduleToDB() async throws {
        let blockItems = try blockItemStore.fetch()
        let scheduleItems = try blockItemStore.fetch()
        guard blockItems.isEmpty || scheduleItems.isEmpty else { return }
        
        let blockItem = ProtectedBlockItem(name: "Block",
                                  emoji: "❌",
                                  blockedContent: state.selection)
        
        
        let startTime = Calendar.current.dateComponents([.hour, .minute], from: state.startTime)
        let endTime = Calendar.current.dateComponents([.hour, .minute], from: state.endTime)
        
        let startComponent = TimeComponents(hour: startTime.hour!, minute: startTime.minute!)!
        let endComponent = TimeComponents(hour: endTime.hour!, minute: endTime.minute!)!
        
        print(startComponent)
        print(endComponent)
        
        let schedule = ProtectedSchedule(emoji: "🕑",
                                name: "Schedule",
                                days: state.daySelection,
                                startTime: startComponent,
                                endTime: endComponent,
                                isActive: false)
        
        do {
            try await blockItemStore.insert(blockItem)
            try await scheduleStore.insert(schedule)
        } catch {
            state.error = error
        }
        
        fetchAllItems()
    }
    
    func fetchAllItems() {
        do {
            try state.schedules = scheduleStore.fetch()
            try state.blockItems = blockItemStore.fetch()
        } catch {
            state.error = error
        }
    }
    
    func appendBlockItemToSchedule() {
        do {
            let blockItem = try blockItemStore.fetch(descriptor: .init()).first!
            let schedule = try scheduleStore.fetch(descriptor: .init()).first!
            
            schedule.blockItems?.append(blockItem)
        } catch {
            state.error = error
        }
    }
    
    func blockSelectionDuringSchedule() async {
        do {
            let blockItem = try blockItemStore.fetch(descriptor: .init()).first!
            let schedule = try scheduleStore.fetch(descriptor: .init()).first!
            
            try await shieldManager.block(specific: blockItem.blockedContent, schedule: schedule)
        } catch {
            state.error = error
        }
    }
    
    func blockSelection() async {
        do {
            try await shieldManager.block(specific: state.selection)
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
