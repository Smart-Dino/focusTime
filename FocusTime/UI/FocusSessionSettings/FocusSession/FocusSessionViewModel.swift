//
//  FocusSessionViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import Foundation

/// The ViewModel for the FocusSetupView.
@MainActor
@Observable
class FocusSessionViewModel {
    
    // MARK: - Published State
    
    var listName: String = "Focus Session"
    var isDurationPickerPresented: Bool = false
    var selectedHours: Int = 0
    var selectedMinutes: Int = 30
    var scheduleForLater: Bool = false
    var selectedPresetID: UUID?

    let presets: [FocusPreset] = [
        .init(name: "Morning\nRoutine", iconName: "sun.max.fill"),
        .init(name: "Social\nDetox", iconName: "message.fill"),
        .init(name: "Work\nSprint", iconName: "stopwatch.fill"),
        .init(name: "Zero\nDistraction", iconName: "nosign"),
        .init(name: "Study", iconName: "books.vertical.fill"),
        .init(name: "Creative", iconName: "paintpalette.fill"),
        .init(name: "Mindfulness", iconName: "brain.head.profile"),
        .init(name: "Reading", iconName: "book.fill")
    ]
    
    // MARK: - Computed Properties
    
    var isStartButtonEnabled: Bool {
        !listName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var formattedDuration: String {
           if selectedHours > 0 {
               return "\(selectedHours)h \(selectedMinutes)m"
           } else {
               return "\(selectedMinutes)m"
           }
       }
    
    
    
    // MARK: - User Intent Methods
    
    func clearFocusName() {
           listName = ""
       }
    
    func presentDurationPicker() {
            isDurationPickerPresented = true
        }
    
    
    
    
    
    
    
    
    /// Logic to handle tapping on a preset icon.
    func selectPreset(_ preset: FocusPreset) {
        if selectedPresetID == preset.id {
            selectedPresetID = nil 
        } else {
            selectedPresetID = preset.id
        }
    }
    
    /// Logic for when the main start button is tapped.
    func startTapped() {
        print("Start button tapped!")
        print("Current List Name: \(listName)")
        print("Schedule for Later is: \(scheduleForLater)")
        if let selectedPresetID, let preset = presets.first(where: { $0.id == selectedPresetID }) {
            print("Selected Preset: \(preset.name)")
        } else {
            print("No preset selected.")
        }
    }
}
