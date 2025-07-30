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

/// Days Picker enum
enum Weekday: String, CaseIterable, Identifiable, Comparable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var id: String { rawValue }
    
    var fullName: String {
        switch self {
        case .monday: return String(
            localized: "Monday",
            table: "SessionLocalizable",
            comment: "Full name for Monday"
        )
        case .tuesday: return String(
            localized: "Tuesday",
            table: "SessionLocalizable",
            comment: "Full name for Tuesday"
        )
        case .wednesday: return String(
            localized: "Wednesday",
            table: "SessionLocalizable",
            comment: "Full name for Wednesday"
        )
        case .thursday: return String(
            localized: "Thursday",
            table: "SessionLocalizable",
            comment: "Full name for Thursday"
        )
        case .friday: return String(
            localized: "Friday",
            table: "SessionLocalizable",
            comment: "Full name for Friday"
        )
        case .saturday: return String(
            localized: "Saturday",
            table: "SessionLocalizable",
            comment: "Full name for Saturday"
        )
        case .sunday: return String(
            localized: "Sunday",
            table: "SessionLocalizable",
            comment: "Full name for Sunday"
        )
        }
    }
    
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        let order: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}
