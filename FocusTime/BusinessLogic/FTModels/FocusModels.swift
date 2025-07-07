//
//  FocusModels.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import Foundation

// MARK: - Placeholder models

public enum Weekday: String, CaseIterable, Identifiable, Comparable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    public var id: String { rawValue }
    
    public var shortName: String {
        switch self {
        case .monday: return String(localized: "Mon", comment: "Short name for Monday")
        case .tuesday: return String(localized: "Tue", comment: "Short name for Tuesday")
        case .wednesday: return String(localized: "Wed", comment: "Short name for Wednesday")
        case .thursday: return String(localized: "Thu", comment: "Short name for Thursday")
        case .friday: return String(localized: "Fri", comment: "Short name for Friday")
        case .saturday: return String(localized: "Sat", comment: "Short name for Saturday")
        case .sunday: return String(localized: "Sun", comment: "Short name for Sunday")
        }
    }
    
    public static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        let order: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}


// MARK: - FocusPreset Enum
public enum FocusPreset: String, CaseIterable, Identifiable {
    case morningRoutine
    case socialDetox
    case workSprint
    case zeroDistraction
    case study
    case creative
    case mindfulness
    case reading
    
    public var id: String { rawValue }
    
    public var name: String {
        switch self {
        case .morningRoutine: return String(localized: "Morning\nRoutine", comment: "Focus preset: Morning Routine")
        case .socialDetox: return String(localized: "Social\nDetox", comment: "Focus preset: Social Detox")
        case .workSprint: return String(localized: "Work\nSprint", comment: "Focus preset: Work Sprint")
        case .zeroDistraction: return String(localized: "Zero\nDistraction", comment: "Focus preset: Zero Distraction")
        case .study: return String(localized: "Study", comment: "Focus preset: Study")
        case .creative: return String(localized: "Creative", comment: "Focus preset: Creative")
        case .mindfulness: return String(localized: "Mindfulness", comment: "Focus preset: Mindfulness")
        case .reading: return String(localized: "Reading", comment: "Focus preset: Reading")
        }
    }
    
    public var iconName: String {
        switch self {
        case .morningRoutine: return "☀️"
        case .socialDetox: return "📴"
        case .workSprint: return "⏱️"
        case .zeroDistraction: return "🚫"
        case .study: return "📚"
        case .creative: return "🎨"
        case .mindfulness: return "🧠"
        case .reading: return "📖"
        }
    }
}

// MARK: - ScheduleConfiguration Struct
public struct ScheduleConfiguration {
    var listName: String
    var scheduleForLater: Bool
    var scheduledDays: Set<Weekday>
    var startTime: Date
    var endTime: Date
    var selectedPreset: FocusPreset?
    var selectedHours: Int
    var selectedMinutes: Int
}
