//
//  ScheduleConfigurationViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 24.07.25.
//

import SwiftUI

@Observable
@MainActor
final class ScheduleConfigurationViewModel {
    
    // MARK: - Enum
    enum ScheduleSheetType: Identifiable, Hashable {
        case durationPicker
        case startTimePicker
        case endTimePicker
        case appBlockerSheet
        
        var id: Int { self.hashValue }
    }
    
    // MARK: - State
    struct State {
        var scheduleConfiguration: ScheduleConfiguration
        var activeSheet: ScheduleSheetType?
        @FocusState var isEmojiTextFieldFocused: Bool
        
        // MARK: - Computed Properties
        /// Formatted string representing the selected duration (hours and minutes).
        var formattedDuration: String {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .abbreviated
            formatter.allowedUnits = [.hour, .minute]
            formatter.zeroFormattingBehavior = .dropAll
            
            if scheduleConfiguration.selectedHours == 0 && scheduleConfiguration.selectedMinutes == 0 {
                return String(localized: "0m", table: "SessionLocalizable", comment: "Zero minutes duration")
            }
            
            return formatter.string(from: TimeInterval(scheduleConfiguration.selectedHours * 3600 + scheduleConfiguration.selectedMinutes * 60)) ?? String(localized: "0m", table: "SessionLocalizable", comment: "Fallback zero minutes duration")
        }
        
        /// Formatted string representing the selected scheduled days.
        var formattedFullScheduledDays: String {
            if scheduleConfiguration.scheduledDays.count == Weekday.allCases.count {
                return String(localized: "Every Day", table: "SessionLocalizable", comment: "Scheduled for every day")
            }
            if scheduleConfiguration.scheduledDays == Set([.saturday, .sunday]) {
                return String(localized: "Weekends", table: "SessionLocalizable", comment: "Scheduled for weekends")
            }
            if scheduleConfiguration.scheduledDays == Set([.monday, .tuesday, .wednesday, .thursday, .friday]) {
                return String(localized: "Weekdays", table: "SessionLocalizable", comment: "Scheduled for weekdays")
            }
            
            let sortedDays = scheduleConfiguration.scheduledDays.sorted(by: <)
            return sortedDays.map { $0.fullName }.joined(separator: ", ")
        }
        
        /// DateFormatter for displaying time.
        private let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = nil
            formatter.timeStyle = .short
            return formatter
        }()
        
        /// Formatted string representing the selected start time.
        var formattedStartTime: String {
            timeFormatter.string(from: scheduleConfiguration.startTime)
        }
        
        /// Formatted string representing the selected end time.
        var formattedEndTime: String {
            timeFormatter.string(from: scheduleConfiguration.endTime)
        }
        
        init(
            scheduleConfiguration: ScheduleConfiguration = .default,
            activeSheet: ScheduleSheetType? = nil
        ) {
            self.scheduleConfiguration = scheduleConfiguration
            self.activeSheet = activeSheet
        }
    }
    
    // MARK: - Properties
    private(set) var state: State
    
    // MARK: - Initializers
    init(state: State = State()) {
        self.state = state
    }

    // MARK: - Methods
    /// Sets the list name in the state.
    /// - Parameter listName: The new list name.
    func setListName(listName: String) {
        state.scheduleConfiguration.listName = listName
    }

    /// Toggles the 'schedule for later' setting.
    /// - Parameter isOn: A boolean indicating whether scheduling for later is active.
    func setScheduleForLater(isOn: Bool) {
        state.scheduleConfiguration.scheduleForLater = isOn
    }

    /// Toggles the selection of a specific weekday for scheduling.
    /// - Parameters:
    ///   - day: The weekday to add or remove.
    ///   - isSelected: A boolean indicating whether the day should be selected.
    func setScheduledDay(_ day: Weekday, isSelected: Bool) {
        if isSelected {
            state.scheduleConfiguration.scheduledDays.insert(day)
        } else {
            state.scheduleConfiguration.scheduledDays.remove(day)
        }
    }

    /// Handles the tap gesture on the emoji preset icon, clearing the selected preset and allowing custom emoji input.
    func handlePresetIconTap() {
        state.scheduleConfiguration.selectedPreset = nil
        state.isEmojiTextFieldFocused = true
    }

    /// Sets the custom preset emoji.
    /// - Parameter emoji: The custom emoji string. Only the first character is kept.
    func setCustomPresetEmoji(emoji: String) {
        state.scheduleConfiguration.customPresetEmoji = String(emoji.prefix(1))
        if !emoji.isEmpty {
            state.scheduleConfiguration.selectedPreset = nil
        }
    }

    /// Updates the focus state of the emoji text field.
    /// - Parameter focused: The new focus state.
    func setEmojiTextFieldFocus(to focused: Bool) {
        state.isEmojiTextFieldFocused = focused
    }

    /// Updates the selected hours in the schedule configuration.
    /// - Parameter hours: The number of hours to set for the focus session duration.
    func setHours(hours: Int) {
        state.scheduleConfiguration.selectedHours = hours
    }

    /// Updates the selected minutes value in the schedule configuration.
    /// - Parameter minutes: The number of minutes to set for the scheduled duration.
    func setMinutes(minutes: Int) {
        state.scheduleConfiguration.selectedMinutes = minutes
    }

    /// Updates the start time in the current schedule configuration.
    /// - Parameter startTime: The new start time to set.
    func setStartTime(startTime: Date) {
        state.scheduleConfiguration.startTime = startTime
    }

    /// Updates the end time in the current schedule configuration.
    /// - Parameter endTime: The new end time to set.
    func setEndTime(endTime: Date) {
        state.scheduleConfiguration.endTime = endTime
    }

    /// Updates the selected focus preset in the schedule configuration.
    /// This method is called by the FocusSessionViewModel
    /// to update the child's state based on preset grid selection.
    /// - Parameter selectedPreset: The focus preset to select, or nil triggers a random preset selection.
    func setSelectedPreset(selectedPreset: FocusPreset?) {
        state.scheduleConfiguration.selectedPreset = selectedPreset ?? FocusPreset.allCases.randomElement()
        state.scheduleConfiguration.listName = selectedPreset?.name ?? FocusSessionView.Constants.DefaultValues.listName
        state.scheduleConfiguration.customPresetEmoji = String()
    }

    // MARK: - Intents (Sheet Presentation)

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

    /// Dismisses any currently presented sheet by setting the active sheet to nil.
    func dismissSheet(_ sheet: ScheduleSheetType?) {
        state.activeSheet = nil
    }
}
