//
//  FocusSessionViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI

@Observable
@MainActor
final class FocusSessionViewModel {
    
    @MainActor
    struct State {
        let presets: [FocusPreset] = FocusPreset.allCases
        
        var isInEditingMode: Bool
        var emojiFieldIsFocused = false
        
        var selectedPreset: FocusPreset? {
            let name = scheduleConfigViewModel.state.blockItem.name
            let emoji = scheduleConfigViewModel.state.blockItem.emoji
            
            return FocusPreset.getPreset(for: name, emoji: emoji)
        }
        
        var isStartButtonEnabled: Bool {
            !scheduleConfigViewModel.state.blockItem.name
                .trimmingCharacters(in: .whitespaces).isEmpty
        }
        
        var scheduleConfigViewModel: ScheduleConfigurationViewModel
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
        
        init(
            blockItem: ProtectedBlockItem? = nil
        ) {
            if let blockItem {
                self.isInEditingMode = true
                self.scheduleConfigViewModel = ScheduleConfigurationViewModel(state: .init(blockItem: blockItem))
            } else {
                self.isInEditingMode = false
                self.scheduleConfigViewModel = ScheduleConfigurationViewModel()
            }
        }
    }
    
    // MARK: - Properties
    private(set) var state: State
    
    // MARK: - Initializer
    init(state: State = State()) {
        self.state = state
        
        state.scheduleConfigViewModel.delegate = self
    }
    
    // MARK: - Intents for global actions or actions not covered by ScheduleConfigurationViewModel
    func startTapped() {
        if let selectedPreset = state.selectedPreset {
            print("Selected Preset: \(selectedPreset.name)")
        } else {
            print("No preset selected.")
        }
    }
    
    func setSelectedEmoji(_ emoji: String) {
        state.scheduleConfigViewModel.setCustomPresetEmoji(emoji: emoji)
    }
    
    func setSelectedPreset(selectedPreset: FocusPreset?) {
        state.scheduleConfigViewModel.setSelectedPreset(selectedPreset: selectedPreset)
    }
}

extension FocusSessionViewModel: ScheduleConfigurationDelegate {
    func didChangeEmojiFieldFocusState(isFocused: Bool) {
        state.emojiFieldIsFocused = isFocused
    }
}
