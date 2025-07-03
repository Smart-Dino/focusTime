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
        var sessionConfiguration: SessionConfiguration = SessionConfiguration(
            listName: FocusSessionView.Constants.DefaultValues.listName,
            scheduleForLater: false,
            scheduledDays: [],
            startTime: FocusSessionView.Constants.DefaultValues.startTime,
            endTime: FocusSessionView.Constants.DefaultValues.endTime,
            selectedPresetID: nil,
            // MARK: - Added: Initialize new properties for SessionConfiguration
            selectedHours: FocusSessionView.Constants.DefaultValues.durationHours,
            selectedMinutes: FocusSessionView.Constants.DefaultValues.durationMinutes
        )
        
        // Picker presentation states
        var isDurationPickerPresented: Bool = false
        var isStartTimePickerPresented: Bool = false
        var isEndTimePickerPresented: Bool = false
        var isAppBlockerSheetPresented: Bool = false
    }
    
    var state = State()
    
    // MARK: - Static Data
    let presets: [FocusPreset] = FocusSessionView.Constants.Data.presets
    
    // MARK: - Computed Properties
    var selectedPresetIconName: String? {
        guard let selectedID = state.sessionConfiguration.selectedPresetID else { return nil }
        return presets.first { $0.id == selectedID }?.iconName
    }
    
    var isStartButtonEnabled: Bool {
        !state.sessionConfiguration.listName.trimmingCharacters(in: .whitespaces).isEmpty
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
        if state.sessionConfiguration.selectedPresetID == preset.id {
            state.sessionConfiguration.selectedPresetID = nil
        } else {
            state.sessionConfiguration.selectedPresetID = preset.id
        }
    }
    
    func startTapped() {
        print("Start button tapped!")
        print("Current List Name: \(state.sessionConfiguration.listName)")
        print("Schedule for Later is: \(state.sessionConfiguration.scheduleForLater)")
        if let selectedPresetID = state.sessionConfiguration.selectedPresetID, let preset = presets.first(where: { $0.id == selectedPresetID }) {
            print("Selected Preset: \(preset.name)")
        } else {
            print("No preset selected.")
        }
        print("Scheduled Days: \(state.sessionConfiguration.scheduledDays)")
        print("Start Time: \(state.sessionConfiguration.startTime)")
        print("End Time: \(state.sessionConfiguration.endTime)")
        print("Selected Hours: \(state.sessionConfiguration.selectedHours)")
        print("Selected Minutes: \(state.sessionConfiguration.selectedMinutes)")
    }
}

