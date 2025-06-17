//
//  Schedule.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import Foundation

// An enum to represent the days of the week for scheduling.
enum Weekday: Int, Codable, CaseIterable, Comparable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    // Replace alphabetic sort with the right one.
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct Schedule: Codable, Hashable {
    var days: Set<Weekday>
    var startTime: DateComponents
    var endTime: DateComponents
}
