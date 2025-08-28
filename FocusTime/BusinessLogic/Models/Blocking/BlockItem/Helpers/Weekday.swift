//
//  Weekday.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import Foundation

/// Days of the week, starting with Sunday = 1 to match Calendar.
enum Weekday: Int, Codable, CaseIterable, Identifiable, Hashable, Equatable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        return formatter
    }()
    
    var id: Int { rawValue }
    
    var isWorkDay: Bool {
        switch self {
        case .sunday, .saturday: false
        default: true
        }
    }
    
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
    
    static var weekdays: Set<Weekday> {
        Set(Weekday.allCases.filter({ $0.isWorkDay }))
    }
    
    static var weekends: Set<Weekday> {
        Set(Weekday.allCases.filter({ !$0.isWorkDay }))
    }
    
    static var currentDay: Weekday {
        let weekday = Calendar
            .current
            .dateComponents([.weekday], from: Date())
            .weekday
        
        return Weekday(rawValue: weekday ?? 1) ?? .sunday
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
        Weekday.formatter.weekdaySymbols[rawValue - 1]
    }
}
