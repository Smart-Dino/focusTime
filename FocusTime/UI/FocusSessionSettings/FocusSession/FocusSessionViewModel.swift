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
    
    enum SheetType: Identifiable {
        case durationPicker
        case startTimePicker
        case endTimePicker
        case appBlockerSheet
        
        var id: Int { self.hashValue }
    }
    
    // MARK: - State
    struct State {
        let presets: [FocusPreset] = FocusPreset.allCases
        var scheduleConfiguration: ScheduleConfiguration
        var activeSheet: SheetType?
        
        var selectedPresetIconName: String? {
            scheduleConfiguration.selectedPreset?.iconName
        }
        
        var isStartButtonEnabled: Bool {
            !scheduleConfiguration.listName.trimmingCharacters(in: .whitespaces).isEmpty
        }
        
        init(
            presets: [FocusPreset] = FocusPreset.allCases,
            scheduleConfiguration: ScheduleConfiguration = ScheduleConfiguration(
                listName: FocusSessionView.Constants.DefaultValues.listName,
                scheduleForLater: false,
                scheduledDays: [],
                startTime: FocusSessionView.Constants.DefaultValues.startTime,
                endTime: FocusSessionView.Constants.DefaultValues.endTime,
                selectedPreset: FocusPreset.allCases.randomElement(),
                selectedHours: FocusSessionView.Constants.DefaultValues.durationHours,
                selectedMinutes: FocusSessionView.Constants.DefaultValues.durationMinutes,
                customPresetEmoji: ""
            ),
            activeSheet: SheetType? = nil
        ) {
            var initialConfig = scheduleConfiguration
            if initialConfig.selectedPreset == nil {
                initialConfig.selectedPreset = FocusPreset.allCases.randomElement()
            }
            self.scheduleConfiguration = initialConfig
            self.activeSheet = activeSheet
        }
    }
    
    // MARK: - Properties
    private(set) var state: State
    
    // MARK: - Initializers
    init(state: State = State()) {
        self.state = state
    }

    /// Presents the duration picker sheet by setting the active sheet state.
    func presentDurationPicker() {
        state.activeSheet = .durationPicker
    }

    /// Presents the start time picker sheet by setting the active sheet state.
    func presentStartTimePicker() {
        state.activeSheet = .startTimePicker
    }

    /// Presents the end time picker sheet by setting the active sheet state.
    func presentEndTimePicker() {
        state.activeSheet = .endTimePicker
    }

    /// Presents the app blocker sheet by setting the active sheet state accordingly.
    func presentAppBlockerSheet() {
        state.activeSheet = .appBlockerSheet
    }

    /// Selects or deselects the given focus preset in the schedule configuration.
    /// - Parameter preset: The focus preset to select or deselect. If the preset is already selected, it will be deselected; otherwise, it will become the selected preset.
    func selectPreset(_ preset: FocusPreset) {
        if state.scheduleConfiguration.selectedPreset != preset {
            state.scheduleConfiguration.selectedPreset = preset
            state.scheduleConfiguration.customPresetEmoji = ""
        }
    }

    /// Handles the action when the start button is tapped by printing the current schedule configuration details for debugging purposes.
    func startTapped() {
        print("Start button tapped!")
        print("Current List Name: \(state.scheduleConfiguration.listName)")
        print("Schedule for Later is: \(state.scheduleConfiguration.scheduleForLater)")
        if let selectedPreset = state.scheduleConfiguration.selectedPreset {
            print("Selected Preset: \(selectedPreset.name)")
        } else {
            print("No preset selected.")
        }
        print("Scheduled Days: \(state.scheduleConfiguration.scheduledDays)")
        print("Start Time: \(state.scheduleConfiguration.startTime)")
        print("End Time: \(state.scheduleConfiguration.endTime)")
        print("Selected Hours: \(state.scheduleConfiguration.selectedHours)")
        print("Selected Minutes: \(state.scheduleConfiguration.selectedMinutes)")
        print("Custom Preset Emoji: \(state.scheduleConfiguration.customPresetEmoji)")
    }
    
    /// Dismisses any currently presented sheet by setting the active sheet to nil.
    func needToDismissSheet(_ sheet: SheetType?) {
        state.activeSheet = nil
    }
    
    /// Updates the selected hours in the schedule configuration.
    /// - Parameter hours: The number of hours to set for the focus session duration.
    func setScheduledConfiguration(hours: Int) {
        state.scheduleConfiguration.selectedHours = hours
    }
    
    /// Updates the selected minutes value in the schedule configuration.
    /// - Parameter minutes: The number of minutes to set for the scheduled duration.
    func setScheduledConfiguration(minutes: Int) {
        state.scheduleConfiguration.selectedMinutes = minutes
    }
    
    /// Updates the selected focus preset in the schedule configuration.
    /// - Parameter selectedPreset: The focus preset to select, or nil to clear the selection.
    func setScheduledConfiguration(selectedPreset: FocusPreset?) {
        if let preset = selectedPreset {
            state.scheduleConfiguration.selectedPreset = preset
            state.scheduleConfiguration.listName = preset.name
            state.scheduleConfiguration.customPresetEmoji = ""
        } else if state.scheduleConfiguration.selectedPreset == nil {
            state.scheduleConfiguration.selectedPreset = FocusPreset.allCases.randomElement()
            state.scheduleConfiguration.listName = FocusSessionView.Constants.DefaultValues.listName
            state.scheduleConfiguration.customPresetEmoji = ""
        }
    }
    /// Updates the current schedule configuration with the provided value.
    /// - Parameter scheduleConfiguration: The new schedule configuration to apply.
    func set(scheduleConfiguration: ScheduleConfiguration) {
        state.scheduleConfiguration = scheduleConfiguration
    }
    
    /// Updates the start time in the current schedule configuration.
    /// - Parameter startTime: The new start time to set.
    func set(startTime: Date) {
        state.scheduleConfiguration.startTime = startTime
    }
    
    /// Updates the end time in the current schedule configuration.
    /// - Parameter endTime: The new end time to set.
    func set(endTime: Date) {
        state.scheduleConfiguration.endTime = endTime
    }
    
    func setCustomPresetEmoji(_ emoji: String) {
        state.scheduleConfiguration.customPresetEmoji = emoji
        state.scheduleConfiguration.selectedPreset = nil
    }
    
    func handlePresetIconTap(isEmojiTextFieldFocused: FocusState<Bool>.Binding) {
        state.scheduleConfiguration.selectedPreset = nil
    }
}

