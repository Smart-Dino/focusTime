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
        
        var isInEditingMode: Bool {
            if case .editBlockList = mode { true } else { false }
        }
        
        var isStartButtonEnabled: Bool {
            !scheduleConfigViewModel.state.blockItem.name
                .trimmingCharacters(in: .whitespaces).isEmpty
            && !scheduleConfigViewModel.state.blockItem.emoji
                .trimmingCharacters(in: .whitespaces).isEmpty
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
            scheduleConfigViewModel = ScheduleConfigurationViewModel(blockItemPersistenceManager: blockItemPersistenceManager)
        case .editBlockList(let block):
            scheduleConfigViewModel = ScheduleConfigurationViewModel(state: .init(blockItem: block), blockItemPersistenceManager: blockItemPersistenceManager)
        }
        
        self.state = State(
            mode: mode,
            scheduleConfigViewModel: scheduleConfigViewModel
        )
        
        self.state.scheduleConfigViewModel.delegate = self
    }
    
    // MARK: - Intents
    func startTapped() {
        Task {
            do {
                let savedItem = try await saveSelectedItemToStorage()
                try await deviceActivityRegistrar.registerActivity(during: savedItem)
            } catch {
                state.error = error
            }
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
    private func saveSelectedItemToStorage() async throws -> ProtectedBlockItem {
        var item = state.scheduleConfigViewModel.state.blockItem
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
