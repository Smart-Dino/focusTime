//
//  DateComponents+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 10.07.2025.
//

import Foundation

extension DateComponents {
    /// Returns new `DateComponents` by adding the specified number of seconds
    /// to the current hour, minute, and second. Wraps around at 24 hours.
    ///
    /// - Parameter seconds: The number of seconds to add (can be negative).
    /// - Returns: A new `DateComponents` instance with the updated time.
    ///
    /// Example:
    /// ```swift
    /// let components = DateComponents(hour: 23, minute: 59, second: 50)
    /// let updated = components.adding(seconds: 15)
    /// // updated.hour == 0, updated.minute == 0, updated.second == 5
    /// ```
    func adding(seconds: Int) -> DateComponents {
        let hour = self.hour ?? 0
        let minute = self.minute ?? 0
        let second = self.second ?? 0

        
        let totalSeconds = hour * 3600 + minute * 60 + second + seconds
        let newHour = ((totalSeconds / 3600) % 24 + 24) % 24
        let newMinute = ((totalSeconds % 3600) / 60 + 60) % 60
        let newSecond = ((totalSeconds % 60) + 60) % 60
        
        return DateComponents(hour: newHour, minute: newMinute, second: newSecond)
    }
}
