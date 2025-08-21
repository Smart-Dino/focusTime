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
    private let analyticsManager: AnalyticsManagerProtocol

    // MARK: - Initializer
    init(
        state: State = State(scheduleConfigurationViewModel: ScheduleConfigurationViewModel()),
        analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()
    ) {
        self.state = state
        self.analyticsManager = analyticsManager
        self.state.scheduleConfigViewModel.analyticsManager = analyticsManager
    }
     
     // MARK: - Intents for global actions or actions not covered by ScheduleConfigurationViewModel
     func startTapped() {
         print("Start button tapped!")

         let config = state.scheduleConfigViewModel.state.scheduleConfiguration
         let parameters: [String: Any] = [
             AnalyticsParameterKey.presetName: config.selectedPreset?.name ?? "Custom",
             AnalyticsParameterKey.durationHours: config.selectedHours,
             AnalyticsParameterKey.durationMinutes: config.selectedMinutes,
             AnalyticsParameterKey.isScheduled: config.scheduleForLater
         ]
         analyticsManager.logEvent(name: AnalyticsEvent.startButtonTapped.rawValue, parameters: parameters)

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
