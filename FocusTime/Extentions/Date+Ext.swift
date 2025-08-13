//
//  Date+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 13.08.2025.
//

import Foundation

extension Date {
    static func secondsSinceMidnight(now: Date = .now) -> Int {
        Int(now.timeIntervalSince(Calendar.current.startOfDay(for: now)))
    }
}
