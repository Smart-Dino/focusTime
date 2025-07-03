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
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        case .sunday: return "Sun"
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


// MARK: - FocusPreset Enum (Changed from struct to enum)
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
        case .morningRoutine: return "Morning\nRoutine"
        case .socialDetox: return "Social\nDetox"
        case .workSprint: return "Work\nSprint"
        case .zeroDistraction: return "Zero\nDistraction"
        case .study: return "Study"
        case .creative: return "Creative"
        case .mindfulness: return "Mindfulness"
        case .reading: return "Reading"
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

// MARK: - ScheduleConfiguration Struct (Renamed from SessionConfiguration)
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
