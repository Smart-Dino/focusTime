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
        case Weekday.weekends:
            return String(localized: "weekday_set_weekends", table: "MainLocalizable")
        case Weekday.weekdays:
            return String(localized: "weekday_set_weekdays", table: "MainLocalizable")
        case Set(Weekday.allCases):
            return String(localized: "weekday_set_everyday", table: "MainLocalizable")
        case let days where days.count == 1:
            return days.first!.description
        default:
            return String(localized: "weekday_set_multiple", table: "MainLocalizable")
                .replacingOccurrences(of: "%d", with: "\(self.count)")
        }
    }
}

