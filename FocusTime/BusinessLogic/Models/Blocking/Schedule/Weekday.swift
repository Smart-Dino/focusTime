//
//  Weekday.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import Foundation

import Foundation

/// Days of the week, starting with Sunday = 1 to match Calendar.
enum Weekday: Int, Codable, CaseIterable, Identifiable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    var id: Int { rawValue }
    
    var isWorkDay: Bool {
        switch self {
        case .sunday, .saturday:
            false
        default:
            true
        }
    }
    
    static var weekdays: Set<Weekday> {
        Set(Weekday.allCases.filter({ $0.isWorkDay }))
    }
    
    static var weekends: Set<Weekday> {
        Set(Weekday.allCases.filter({ !$0.isWorkDay }))
    }
    
    /// Returns the days of the week reordered to start with the user's locale preference.
    static var allCases: [Weekday] {
        let start = Calendar.current.firstWeekday
        return [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday].sorted {
            let lhsOffset = ($0.rawValue - start + 7) % 7
            let rhsOffset = ($1.rawValue - start + 7) % 7
            return lhsOffset < rhsOffset
        }
    }
    
    /// Human-readable name of the weekday.
    var description: String {
        switch self {
        case .sunday:    "Sunday"
        case .monday:    "Monday"
        case .tuesday:   "Tuesday"
        case .wednesday: "Wednesday"
        case .thursday:  "Thursday"
        case .friday:    "Friday"
        case .saturday:  "Saturday"
        }
    }
}
