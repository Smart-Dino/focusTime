//
//  DateComponents+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 10.07.2025.
//

import Foundation

extension DateComponents {
    /// Returns new `DateComponents` by adding the specified number of minutes
    /// to the current hour and minute. Wraps around at 24 hours.
    ///
    /// - Parameter minutes: The number of minutes to add (can be negative).
    /// - Returns: A new `DateComponents` instance with the updated time.
    ///
    /// Example:
    /// ```swift
    /// let components = DateComponents(hour: 23, minute: 50)
    /// let updated = components.adding(minutes: 15)
    /// // updated.hour == 0, updated.minute == 5
    /// ```
    func adding(minutes: Int) -> DateComponents? {
        guard let hour = self.hour, let minute = self.minute else { return nil }

        let totalMinutes = hour * 60 + minute + minutes
        let newHour = ((totalMinutes / 60) % 24 + 24) % 24
        let newMinute = ((totalMinutes % 60) + 60) % 60

        return DateComponents(hour: newHour, minute: newMinute)
    }
}
