//
//  ScheduleConfigurationModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 21.07.25.
//

// MARK: ScheduleConfiguration models
import Foundation

/// ScheduleConfiguration Struct
struct ScheduleConfiguration: Equatable {
    var listName: String
    var scheduleForLater: Bool
    var scheduledDays: Set<Weekday>
    var startTime: Date
    var endTime: Date
    var selectedPreset: FocusPreset?
    var selectedHours: Int
    var selectedMinutes: Int
    var customPresetEmoji: String
    
    static var `default`: ScheduleConfiguration {
        ScheduleConfiguration(
            listName: FocusSessionView.Constants.DefaultValues.listName,
            scheduleForLater: false,
            scheduledDays: [],
            startTime: FocusSessionView.Constants.DefaultValues.startTime,
            endTime: FocusSessionView.Constants.DefaultValues.endTime,
            selectedPreset: FocusSessionView.Constants.DefaultValues.initialFocusPreset, 
            selectedHours: FocusSessionView.Constants.DefaultValues.durationHours,
            selectedMinutes: FocusSessionView.Constants.DefaultValues.durationMinutes,
            customPresetEmoji: String()
        )
    }
}
