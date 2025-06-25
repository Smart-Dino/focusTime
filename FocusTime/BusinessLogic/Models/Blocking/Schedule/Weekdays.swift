//
//  Weekdays.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import Foundation

import Foundation

/// Days of the week, starting with Sunday = 1 to match Calendar.
enum Weekday: Int, Codable, CaseIterable, Comparable, Identifiable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    var id: Int { rawValue }
    
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

    // Conform to Comparable based on fixed rawValue order (Sunday = 1).
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// Weekdays: Monday–Friday
    static var weekdays: Set<Weekday> {
        [.monday, .tuesday, .wednesday, .thursday, .friday]
    }

    /// Weekend: Saturday and Sunday
    static var weekend: Set<Weekday> {
        [.saturday, .sunday]
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

extension Set where Element == Weekday {
    /// Returns a user-friendly description for a set of weekdays.
    var daysDescription: String {
        switch self {
        case Weekday.weekend:                "Weekend"
        case Weekday.weekdays:               "Weekdays"
        case Set(Weekday.allCases):          "Every day"
        case let days where days.count == 1: days.first!.description
        default:                             "\(self.count) days"
        }
    }
}
