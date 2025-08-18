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
         var scheduleConfigViewModel: ScheduleConfigurationViewModel

         var isStartButtonEnabled: Bool {
             !scheduleConfigViewModel.state.scheduleConfiguration.listName.trimmingCharacters(in: .whitespaces).isEmpty
         }
         
         init(
            scheduleConfigurationViewModel: ScheduleConfigurationViewModel,
         ) {
             self.scheduleConfigViewModel = scheduleConfigurationViewModel
         }
     }
     
    // MARK: - Properties
    private(set) var state: State

    // MARK: - Initializer
    init(state: State = State(scheduleConfigurationViewModel: ScheduleConfigurationViewModel())) {
        self.state = state
    }
     
     // MARK: - Intents for global actions or actions not covered by ScheduleConfigurationViewModel
     func startTapped() {
         print("Start button tapped!")
         print("Current List Name: \(state.scheduleConfigViewModel.state.scheduleConfiguration.listName)")
         print("Schedule for Later is: \(state.scheduleConfigViewModel.state.scheduleConfiguration.scheduleForLater)")
         if let selectedPreset = state.scheduleConfigViewModel.state.scheduleConfiguration.selectedPreset {
             print("Selected Preset: \(selectedPreset.name)")
         } else {
             print("No preset selected.")
         }
         print("Scheduled Days: \(state.scheduleConfigViewModel.state.scheduleConfiguration.scheduledDays)")
         print("Start Time: \(state.scheduleConfigViewModel.state.scheduleConfiguration.startTime)")
         print("End Time: \(state.scheduleConfigViewModel.state.scheduleConfiguration.endTime)")
         print("Selected Hours: \(state.scheduleConfigViewModel.state.scheduleConfiguration.selectedHours)")
         print("Selected Minutes: \(state.scheduleConfigViewModel.state.scheduleConfiguration.selectedMinutes)")
         print("Custom Preset Emoji: \(state.scheduleConfigViewModel.state.scheduleConfiguration.customPresetEmoji)")
     }
     
     func setSelectedPreset(selectedPreset: FocusPreset?) {
         state.scheduleConfigViewModel.setSelectedPreset(selectedPreset: selectedPreset)
     }
 }
