//
//  FocusSessionViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI

// MARK: - Focus Session Mode
enum FocusSessionMode: Equatable {
    case startFocusing
    case addBlockList
    case editBlockList(_ block: ProtectedBlockItem)
}

// MARK: - Focus Session ViewModel
@Observable
@MainActor
final class FocusSessionViewModel {
    
    // MARK: - State
    @MainActor
    struct State {
        var error: Error?
        
        let presets: [FocusPreset] = FocusPreset.allCases
        let mode: FocusSessionMode
        var scheduleConfigViewModel: ScheduleConfigurationViewModel
        
        var emojiFieldIsFocused = false
        
        var selectedPreset: FocusPreset? {
            let name = scheduleConfigViewModel.state.blockItem.name
            let emoji = scheduleConfigViewModel.state.blockItem.emoji
            return FocusPreset.getPreset(for: name, emoji: emoji)
        }
        
        var isStartButtonDisplayed: Bool {
            mode == .startFocusing
        }
        
        var isSavingButtonsEnabled: Bool {
            let nameFilled = !scheduleConfigViewModel.state.blockItem.name
                .trimmingCharacters(in: .whitespaces).isEmpty
            
            let emojiFilled = !scheduleConfigViewModel.state.blockItem.emoji
                .trimmingCharacters(in: .whitespaces).isEmpty
            
            let blockedContentFilled = !scheduleConfigViewModel.state.blockItem.blockedContent.isEmpty
            
            let daysHasAtLeastOneDay = !scheduleConfigViewModel.state.blockItem.days.isEmpty
            
            return nameFilled && emojiFilled && blockedContentFilled && daysHasAtLeastOneDay
        }

        
        var selectedEmoji: String {
            scheduleConfigViewModel.state.blockItem.emoji
        }
        
        var isDurationSchedule: Bool {
            if case .duration = scheduleConfigViewModel.state.blockItem.type { return true }
            return false
        }
        
        var isScheduled: Bool {
            if case .scheduled = scheduleConfigViewModel.state.blockItem.type { return true }
            return false
        }
    }
    
    // MARK: - Properties
    private(set) var state: State
    
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    
    // MARK: - Initializer
    init(
        mode: FocusSessionMode,
        blockItemPersistenceManager: BlockItemPersistenceManager,
        deviceActivityRegistrar: DeviceActivityRegistrar
    ) {
        self.blockItemPersistenceManager = blockItemPersistenceManager
        self.deviceActivityRegistrar = deviceActivityRegistrar
        
        let scheduleConfigViewModel: ScheduleConfigurationViewModel
        switch mode {
        case .startFocusing, .addBlockList:
            scheduleConfigViewModel = ScheduleConfigurationViewModel(
                deviceActivityRegistrar: deviceActivityRegistrar,
                blockItemPersistenceManager: blockItemPersistenceManager
            )
        case .editBlockList(let block):
            scheduleConfigViewModel = ScheduleConfigurationViewModel(
                state: .init(blockItem: block),
                deviceActivityRegistrar: deviceActivityRegistrar,
                blockItemPersistenceManager: blockItemPersistenceManager
            )
        }
        
        self.state = State(
            mode: mode,
            scheduleConfigViewModel: scheduleConfigViewModel
        )
        
        self.state.scheduleConfigViewModel.delegate = self
    }
    
    // MARK: - Intents
    func saveTapped() async throws {
        do {
            switch state.mode {
            case .startFocusing:
                let item = try await saveSelectedItemToStorage(isTemporary: false)
                try await deviceActivityRegistrar.registerActivity(during: item)
            case .addBlockList:
                let _ = try await saveSelectedItemToStorage(isTemporary: false)
            case .editBlockList:
                try await blockItemPersistenceManager.editBlockItem(
                    blockItem: state.scheduleConfigViewModel.state.blockItem
                )
            }
        } catch {
            state.error = error
            throw error
        }
    }
    
    func startTapped() async throws {
        do {
            let savedItem = try await saveSelectedItemToStorage(isTemporary: true)
            try await deviceActivityRegistrar.registerActivity(during: savedItem)
        } catch {
            state.error = error
            throw error
        }
    }
    
    func startFocusingTapped() async throws {
        do {
            try await deviceActivityRegistrar.registerActivity(during: state.scheduleConfigViewModel.state.blockItem)
        } catch {
            state.error = error
            throw error
        }
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func setSelectedEmoji(_ emoji: String) {
        state.scheduleConfigViewModel.setCustomPresetEmoji(emoji: emoji)
    }
    
    func setSelectedPreset(selectedPreset: FocusPreset?) {
        state.scheduleConfigViewModel.setSelectedPreset(selectedPreset: selectedPreset)
    }
    
    // MARK: - Private Helpers
    private func saveSelectedItemToStorage(isTemporary: Bool) async throws -> ProtectedBlockItem {
        var item = state.scheduleConfigViewModel.state.blockItem
        
        if isTemporary {
            item.isTemporary = true
        }
        
        try await blockItemPersistenceManager.insert(&item)
        
        return item
    }
}

// MARK: - ScheduleConfigurationDelegate
extension FocusSessionViewModel: ScheduleConfigurationDelegate {
    func didChangeEmojiFieldFocusState(isFocused: Bool) {
        state.emojiFieldIsFocused = isFocused
    }
}
