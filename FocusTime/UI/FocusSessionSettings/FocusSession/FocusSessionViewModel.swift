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
        state: State = State(scheduleConfigurationViewModel: ScheduleConfigurationViewModel())
    ) {
        self.state = state
        
        state.scheduleConfigViewModel.delegate = self
    }
     
     // MARK: - Intents for global actions or actions not covered by ScheduleConfigurationViewModel
     func startTapped() {
         print("Start button tapped!")

         let config = state.scheduleConfigViewModel.state.scheduleConfiguration
         let parameters: [String: Any] = [
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.presetName: config.selectedPreset?.name ?? "Custom",
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.durationHours: config.selectedHours,
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.durationMinutes: config.selectedMinutes,
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.isScheduled: config.scheduleForLater
         ]
         analyticsManager.logEvent(name: FocusSessionView.Constants.ScheduleSessionAnalyticsKeys.startButtonTapped.rawValue, parameters: parameters)

         print("Current List Name: \(config.listName)")
         print("Schedule for Later is: \(config.scheduleForLater)")
         if let selectedPreset = config.selectedPreset {
             print("Selected Preset: \(selectedPreset.name)")
         } else {
             print("No preset selected.")
         }
         print("Scheduled Days: \(config.scheduledDays)")
         print("Start Time: \(config.startTime)")
         print("End Time: \(config.endTime)")
         print("Selected Hours: \(config.selectedHours)")
         print("Selected Minutes: \(config.selectedMinutes)")
         print("Custom Preset Emoji: \(config.customPresetEmoji)")
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
