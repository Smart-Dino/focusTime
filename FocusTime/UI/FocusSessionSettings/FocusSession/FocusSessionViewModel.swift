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
        var scheduleConfiguration: ScheduleConfiguration = ScheduleConfiguration(
            listName: FocusSessionView.Constants.DefaultValues.listName,
            scheduleForLater: false,
            scheduledDays: [],
            startTime: FocusSessionView.Constants.DefaultValues.startTime,
            endTime: FocusSessionView.Constants.DefaultValues.endTime,
            selectedPreset: nil,
            selectedHours: FocusSessionView.Constants.DefaultValues.durationHours,
            selectedMinutes: FocusSessionView.Constants.DefaultValues.durationMinutes
        )

        var activeSheet: SheetType?
    }

    // MARK: - Properties
    var state: State

    // MARK: - Static Data
    let presets: [FocusPreset] = FocusPreset.allCases

    // MARK: - Initializers
    init(state: State = State()) {
        self.state = state
    }

    // MARK: - Computed Properties
    var selectedPresetIconName: String? {
        state.scheduleConfiguration.selectedPreset?.iconName
    }

    var isStartButtonEnabled: Bool {
        !state.scheduleConfiguration.listName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Action Methods (Public API)
    func presentDurationPicker() {
        state.activeSheet = .durationPicker
    }

    func presentStartTimePicker() {
        state.activeSheet = .startTimePicker
    }

    func presentEndTimePicker() {
        state.activeSheet = .endTimePicker
    }

    func presentAppBlockerSheet() {
        state.activeSheet = .appBlockerSheet
    }

    func selectPreset(_ preset: FocusPreset) {
        if state.scheduleConfiguration.selectedPreset == preset {
            state.scheduleConfiguration.selectedPreset = nil
        } else {
            state.scheduleConfiguration.selectedPreset = preset
        }
    }

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
    }
}
