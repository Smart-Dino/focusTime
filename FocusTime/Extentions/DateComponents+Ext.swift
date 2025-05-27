//
//  DateComponents+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.05.2025.
//

import Foundation

extension DateComponents {
    
    // TODO: This method will probably have to be reworked for localization
    /// Returns a concise string for the largest significant time unit, e.g., "2 years", "1 month", or "0 seconds".
    ///
    /// - Prioritizes from years down to seconds.
    /// - If all components are nil or zero, defaults to "0 seconds".
    /// - For positive 1, the unit is singular (e.g., "1 year"); otherwise, it's plural (e.g., "0 years", "-1 years", "2 years").
    var descriptiveLargestUnitString: String {
        if let years = self.year, years != 0 {
            return years == 1 ? "year" : "\(years) years"
        }
        if let months = self.month, months != 0 {
            return months == 1 ? "month" : "\(months) months"
        }
        if let days = self.day, days != 0 {
            if days == 7 {
                return "week"
            } else if days == 1 {
                return "day"
            } else {
                return "\(days) days"
            }
        }
        if let hours = self.hour, hours != 0 {
            return hours == 1 ? "hour" : "\(hours) hours"
        }
        if let minutes = self.minute, minutes != 0 {
            return minutes == 1 ? "minute" : "\(minutes) minutes"
        }
        if let seconds = self.second, seconds != 0 {
            return seconds == 1 ? "second" : "\(seconds) seconds"
        }

        // Default for zero or unspecified duration
        return "0 seconds"
    }

}
