//
//  FocusSessionViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import Foundation

@Observable
@MainActor
final class FocusSessionViewModel {
    
    // MARK: - State
    struct State {
        var listName: String = FocusSessionView.Constants.DefaultValues.listName
        var isDurationPickerPresented: Bool = false
        var selectedHours: Int = FocusSessionView.Constants.DefaultValues.durationHours
        var selectedMinutes: Int = FocusSessionView.Constants.DefaultValues.durationMinutes
        var scheduleForLater: Bool = false
        var selectedPresetID: UUID?
        var scheduledDays: Set<Weekday> = []
        var startTime: Date = FocusSessionView.Constants.DefaultValues.startTime
        var endTime: Date = FocusSessionView.Constants.DefaultValues.endTime
        var isStartTimePickerPresented: Bool = false
        var isEndTimePickerPresented: Bool = false
        var isAppBlockerSheetPresented: Bool = false
    }
    
    var state = State()
    
    // MARK: - Static Data
    let presets: [FocusPreset] = FocusSessionView.Constants.Data.presets
    
    // MARK: - Computed Properties
    var selectedPresetIconName: String? {
        guard let selectedID = state.selectedPresetID else { return nil }
        return presets.first { $0.id == selectedID }?.iconName
    }
    
    var isStartButtonEnabled: Bool {
        !state.listName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var formattedDuration: String {
        let h = FocusSessionView.Constants.Time.hourSuffix
        let m = FocusSessionView.Constants.Time.minuteSuffix
        if state.selectedHours > 0 {
            return "\(state.selectedHours)\(h) \(state.selectedMinutes)\(m)"
        } else {
            return "\(state.selectedMinutes)\(m)"
        }
    }
    
    var formattedScheduledDays: String {
        if state.scheduledDays.isEmpty {
            return "Never"
        }
        if state.scheduledDays.count == Weekday.allCases.count {
            return "Every Day"
        }
        if state.scheduledDays == [.saturday, .sunday] {
            return "Weekends"
        }
        if state.scheduledDays == [.monday, .tuesday, .wednesday, .thursday, .friday] {
            return "Weekdays"
        }
        
        let sortedDays = state.scheduledDays.sorted()
        return sortedDays.map { $0.shortName }.joined(separator: ", ")
    }
    
    private let twentyFourHourTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter
    }()
    
    var formattedStartTime: String {
        twentyFourHourTimeFormatter.string(from: state.startTime)
    }
    
    var formattedEndTime: String {
        twentyFourHourTimeFormatter.string(from: state.endTime)
    }
    
    // MARK: - User Intent Methods
    func updateListName(to newName: String) {
        state.listName = newName
    }
    
    func updateScheduleToggle(to newValue: Bool) {
        state.scheduleForLater = newValue
    }
    
    func updateDuration(hours: Int, minutes: Int) {
        state.selectedHours = hours
        state.selectedMinutes = minutes
    }
    
    func presentDurationPicker() {
        state.isDurationPickerPresented = true
    }
    
    func presentStartTimePicker() {
        state.isStartTimePickerPresented = true
    }
    
    func presentEndTimePicker() {
        state.isEndTimePickerPresented = true
    }
    
    func updateStartTime(to date: Date) {
        state.startTime = date
    }
    
    func updateEndTime(to date: Date) {
        state.endTime = date
    }
    
    func presentAppBlockerSheet() {
        state.isAppBlockerSheetPresented = true
    }
    
    private func selectPreset(_ preset: FocusPreset) {
        if state.selectedPresetID == preset.id {
            state.selectedPresetID = nil
        } else {
            state.selectedPresetID = preset.id
        }
    }
    
    func startTapped() {
        print("Start button tapped!")
        print("Current List Name: \(state.listName)")
        print("Schedule for Later is: \(state.scheduleForLater)")
        if let selectedPresetID = state.selectedPresetID, let preset = presets.first(where: { $0.id == selectedPresetID }) {
            print("Selected Preset: \(preset.name)")
        } else {
            print("No preset selected.")
        }
    }
}

// MARK: - Extensions
extension FocusSessionViewModel: SessionConfigurationViewDelegate {
    func sessionConfigurationDidUpdateListName(to newName: String) {
        updateListName(to: newName)
    }
    
    func sessionConfigurationDidUpdateScheduleToggle(to newValue: Bool) {
        updateScheduleToggle(to: newValue)
    }
    
    func sessionConfigurationDidTapDuration() {
        presentDurationPicker()
    }
    
    
    func sessionConfigurationDidTapStartTime() {
        presentStartTimePicker()
    }
    
    func sessionConfigurationDidTapEndTime() {
        presentEndTimePicker()
    }
    
    func sessionConfigurationDidTapAppsBlocked() {
        presentAppBlockerSheet()
    }
}

extension FocusSessionViewModel: FocusPresetGridViewDelegate {
    func focusPresetGridDidSelectPreset(_ preset: FocusPreset) {
        selectPreset(preset)
    }
}


