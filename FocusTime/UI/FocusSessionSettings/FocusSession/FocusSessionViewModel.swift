//
//  FocusSessionViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import Foundation
import SwiftUI // Needed for Color.init(hex:) in Constants

@Observable
@MainActor
final class FocusSessionViewModel {
    
    // MARK: - State
    struct State {
        // MARK: - Refactored: Consolidate session configuration into one struct
        // Renamed from sessionConfiguration to scheduleConfiguration
        var scheduleConfiguration: ScheduleConfiguration = ScheduleConfiguration(
            listName: FocusSessionView.Constants.DefaultValues.listName,
            scheduleForLater: false,
            scheduledDays: [],
            startTime: FocusSessionView.Constants.DefaultValues.startTime,
            endTime: FocusSessionView.Constants.DefaultValues.endTime,
            selectedPreset: nil, // Changed type to FocusPreset enum
            selectedHours: FocusSessionView.Constants.DefaultValues.durationHours,
            selectedMinutes: FocusSessionView.Constants.DefaultValues.durationMinutes
        )
        
        // Picker presentation states
        var isDurationPickerPresented: Bool = false
        var isStartTimePickerPresented: Bool = false
        var isEndTimePickerPresented: Bool = false
        var isAppBlockerSheetPresented: Bool = false
    }
    
    // MARK: - Properties
    var state: State // Changed to a non-defaulted property
    
    // MARK: - Static Data
    // Presets are now directly from the FocusPreset.allCases
    let presets: [FocusPreset] = FocusPreset.allCases
    
    // MARK: - Initializers
    init(state: State = State()) { // Added initializer for dependency injection
        self.state = state
    }
    
    // MARK: - Computed Properties
    // This computed property is used by the View and derives from the ViewModel's state.
    // Keeping it here is appropriate as it combines state and static data.
    var selectedPresetIconName: String? {
        state.scheduleConfiguration.selectedPreset?.iconName
    }
    
    var isStartButtonEnabled: Bool {
        !state.scheduleConfiguration.listName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - User Intent Methods (Public API for View)
    func presentDurationPicker() {
        state.isDurationPickerPresented = true
    }
    
    func presentStartTimePicker() {
        state.isStartTimePickerPresented = true
    }
    
    func presentEndTimePicker() {
        state.isEndTimePickerPresented = true
    }
    
    func presentAppBlockerSheet() {
        state.isAppBlockerSheetPresented = true
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
