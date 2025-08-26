//
//  ScheduleConfigurationViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 24.07.25.
//

import SwiftUI

@MainActor
protocol ScheduleConfigurationDelegate: AnyObject {
    func didChangeEmojiFieldFocusState(isFocused: Bool)
}

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
    struct State: Equatable {
        var blockItem: ProtectedBlockItem = .default
        
        var durationHours: Int = FocusSessionView.Constants.DefaultValues.durationHours
        var durationMinutes: Int = FocusSessionView.Constants.DefaultValues.durationMinutes
        var startTime: Date = FocusSessionView.Constants.DefaultValues.startTime
        var endTime: Date = FocusSessionView.Constants.DefaultValues.endTime
        
        var isScheduledForLater: Bool = false
        
        var activeSheet: ScheduleSheetType? = nil
    }
    
    // MARK: - Properties
    private(set) var state: State
    weak var delegate: ScheduleConfigurationDelegate?
    
    // MARK: - Initializers
    init(state: State = State()) {
        self.state = state
    }

    // MARK: - Methods
    /// Sets the list name in the state.
    /// - Parameter listName: The new list name.
    func setListName(listName: String) {
        state.blockItem.name = listName
    }

    /// Toggles the 'schedule for later' setting.
    /// - Parameter isOn: A boolean indicating whether scheduling for later is active.
    func setScheduleForLater(isOn: Bool) {
        state.isScheduledForLater = isOn
    }
    
    func refreshBlockItem() {
        if state.isScheduledForLater {
            let startTime = try? TimeComponents(from: state.startTime)
            let endTime = try? TimeComponents(from: state.endTime)
            
            state.blockItem.type = .scheduled(
                startTime: startTime ?? .default,
                endTime: endTime ?? .default
            )
        } else {
            let hoursAsSeconds = state.durationHours * 60 * 60
            let minutesAsSeconds = state.durationMinutes * 60
            let totalSeconds = hoursAsSeconds + minutesAsSeconds
            
            state.blockItem.type = .duration(
                duration: DurationComponents(seconds: totalSeconds)
            )
        }
    }
    
    func updateDelegateEmojiFocusStateStatus(with isFocused: Bool) {
        delegate?.didChangeEmojiFieldFocusState(isFocused: isFocused)
    }

    /// Toggles the selection of a specific weekday for scheduling.
    /// - Parameters:
    ///   - day: The weekday to add or remove.
    ///   - isSelected: A boolean indicating whether the day should be selected.
    func setScheduledDay(_ day: Weekday, isSelected: Bool) {
        if isSelected {
            state.blockItem.days.insert(day)
        } else {
            state.blockItem.days.remove(day)
        }
    }

    /// Sets the custom preset emoji.
    /// - Parameter emoji: The custom emoji string. Only the first character is kept.
    func setCustomPresetEmoji(emoji: String) {
        state.blockItem.emoji = emoji
    }
    
    /// Updates the selected hours in the schedule configuration.
    /// - Parameter hours: The number of hours to set for the focus session duration.
    func setHours(hours: Int) {
        state.durationHours = hours
    }

    /// Updates the selected minutes value in the schedule configuration.
    /// - Parameter minutes: The number of minutes to set for the scheduled duration.
    func setMinutes(minutes: Int) {
        state.durationMinutes = minutes
    }

    /// Updates the start time in the current schedule configuration.
    /// - Parameter startTime: The new start time to set.
    func setStartTime(startTime: Date) {
        state.startTime = startTime
    }

    /// Updates the end time in the current schedule configuration.
    /// - Parameter endTime: The new end time to set.
    func setEndTime(endTime: Date) {
        state.endTime = endTime
    }

    /// Updates the selected focus preset in the schedule configuration.
    /// This method is called by the FocusSessionViewModel
    /// to update the child's state based on preset grid selection.
    /// - Parameter selectedPreset: The focus preset to select, or nil triggers a random preset selection.
    func setSelectedPreset(selectedPreset: FocusPreset?) {
        guard let selectedPreset else { return }
        state.blockItem.name = selectedPreset.name
        state.blockItem.emoji = selectedPreset.emoji
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
