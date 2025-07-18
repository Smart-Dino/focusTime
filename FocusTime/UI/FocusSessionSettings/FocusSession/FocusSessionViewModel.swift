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
                selectedPreset: nil,
                selectedHours: FocusSessionView.Constants.DefaultValues.durationHours,
                selectedMinutes: FocusSessionView.Constants.DefaultValues.durationMinutes
            ),
            activeSheet: SheetType? = nil
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
    
    func needToDismissSheet(_ sheet: SheetType?) {
        state.activeSheet = nil
    }
    
    func setScheduledConfiguration(hours: Int) {
        state.scheduleConfiguration.selectedHours = hours
    }
    
    func setScheduledConfiguration(minutes: Int) {
        state.scheduleConfiguration.selectedMinutes = minutes
    }
    
    func setScheduledConfiguration(selectedPreset: FocusPreset?) {
        state.scheduleConfiguration.selectedPreset = selectedPreset
    }
    
    func set(scheduleConfiguration: ScheduleConfiguration) {
        state.scheduleConfiguration = scheduleConfiguration
    }
    
    func set(startTime: Date) {
        state.scheduleConfiguration.startTime = startTime
    }
    
    func set(endTime: Date) {
        state.scheduleConfiguration.endTime = endTime
    }
}
