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
    private var analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()
    
    // MARK: - Initializer
    init(
        state: State = State()
    ) {
        self.state = state
        self.state.scheduleConfigViewModel.delegate = self
    }
     
    // MARK: - Intents
    func startTapped() {
        print("Start button tapped!")
        
        // Ensure the blockItem's type is up-to-date before logging
        state.scheduleConfigViewModel.refreshBlockItem()

        let configState = state.scheduleConfigViewModel.state
        
        let parameters: [String: Any] = [
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.presetName: state.selectedPreset?.name ?? "Custom",
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.durationHours: configState.durationHours,
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.durationMinutes: configState.durationMinutes,
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.isScheduled: configState.isScheduledForLater
        ]
        
        analyticsManager.logEvent(
            name: FocusSessionView.Constants.ScheduleSessionAnalyticsKeys.startButtonTapped.rawValue,
            parameters: parameters
        )
        
        if let selectedPreset = state.selectedPreset {
            print("Selected Preset: \(selectedPreset.name)")
        } else {
            print("Custom session named: \(configState.blockItem.name)")
        }
    }
     
    func setSelectedEmoji(_ emoji: String) {
        state.scheduleConfigViewModel.setCustomPresetEmoji(emoji: emoji)
    }
    
    func setSelectedPreset(selectedPreset: FocusPreset?) {
        state.scheduleConfigViewModel.setSelectedPreset(selectedPreset: selectedPreset)
    }
    
}

// MARK: - ScheduleConfigurationDelegate
extension FocusSessionViewModel: ScheduleConfigurationDelegate {
   func didChangeEmojiFieldFocusState(isFocused: Bool) {
       state.emojiFieldIsFocused = isFocused
   }
}
