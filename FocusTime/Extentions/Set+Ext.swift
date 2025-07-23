//
//  Set+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.07.2025.
//

import Foundation

extension Set where Element == Weekday {
    var description: String {
        switch self {
        case Weekday.weekends:      return "Weekend"
        case Weekday.weekdays:      return "Weekdays"
        case Set(Weekday.allCases): return "Every day"
        case let days where days.count == 1: return days.first!.description
        default: return "\(self.count) days"
        }
    }
}
