//
//  Weekdays.swift
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
    
    #warning("Finish this property")
    var weekdays: Set<Self> {
        Set(Weekday.allCases.filter({ !$0.isWorkDay }))
    }
    
    #warning("Finish this property")
    static var allCases: [Self] {
        []
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

    /// Returns the days of the week reordered to start with the user's locale preference.
    static func localizedOrder(using calendar: Calendar = .current) -> [Weekday] {
        let start = calendar.firstWeekday
        return allCases.sorted {
            let lhsOffset = ($0.rawValue - start + 7) % 7
            let rhsOffset = ($1.rawValue - start + 7) % 7
            return lhsOffset < rhsOffset
        }
    }
}
