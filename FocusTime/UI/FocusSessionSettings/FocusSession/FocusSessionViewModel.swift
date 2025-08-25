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
         
         var selectedPreset: FocusPreset? {
             let name = scheduleConfigViewModel.state.blockItem.name
             let emoji = scheduleConfigViewModel.state.blockItem.emoji
             
             return FocusPreset.getPreset(for: name, emoji: emoji)
         }

         var isStartButtonEnabled: Bool {
             !scheduleConfigViewModel.state.blockItem.name
                 .trimmingCharacters(in: .whitespaces).isEmpty
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
         if let selectedPreset = state.selectedPreset {
             print("Selected Preset: \(selectedPreset.name)")
         } else {
             print("No preset selected.")
         }
     }
     
     func setSelectedPreset(selectedPreset: FocusPreset?) {
         state.scheduleConfigViewModel.setSelectedPreset(selectedPreset: selectedPreset)
     }
 }
