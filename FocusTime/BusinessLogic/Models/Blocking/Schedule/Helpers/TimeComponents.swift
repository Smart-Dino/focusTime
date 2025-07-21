//
//  TimeComponents.swift
//  FocusTime
//
//  Created by Maksym Horobets on 19.06.2025.
//

import Foundation

// Had to create my own because SwiftData does not like DateComponents
// Fatal error: Unexpected property within Persisted Struct/Enum: _CalendarProtocol
// https://fatbobman.com/en/posts/considerations-for-using-codable-and-enums-in-swiftdata-models/#:~:text=Such%20errors%20indicate,of%20the%20model.
/// A simplified alternative to `DateComponents` that works with SwiftData.
/// Represents a time of day in hours and minutes, stored as seconds since midnight (00:00:00 UTC).
struct TimeComponents: Codable, Hashable, CustomStringConvertible {
    let secondsSinceMidnight: Int
    
    /// Initializes with seconds since midnight (00:00:00 UTC).
    /// - Parameter secondsSince1970: Number of seconds since midnight; must be in range 0..<86400.
    init?(secondsSince1970: Int) {
        guard (0..<24*60*60).contains(secondsSince1970) else { return nil }
        self.secondsSinceMidnight = secondsSince1970
    }
    
    /// Initializes with hour and minute components.
    /// - Parameters:
    ///   - hour: Hour value in 0..<24.
    ///   - minute: Minute value in 0..<60.
    init?(hour: Int, minute: Int) {
        guard (0..<24).contains(hour), (0..<60).contains(minute) else { return nil }
        let hoursAsSeconds = hour * 60 * 60
        let minutesAsSeconds = minute * 60
        let totalSeconds = hoursAsSeconds + minutesAsSeconds
        self.secondsSinceMidnight = totalSeconds
    }
    
    /// Initializes from a Date, extracting the hour and minute in GMT timezone.
    /// - Parameter date: The Date to extract time components from.
    init?(from date: Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour,
              let minute = components.minute else { return nil }
        
        self.init(hour: hour, minute: minute)
    }

    /// Returns localized time string in the user's current calendar and time zone,
    /// formatted with the hour and minute components (e.g. "8:30 AM" or "20:30").
    var description: String {
        // Prepare formatter.
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        let date = Calendar.current.date(from: dateComponents) ?? Date()
        
        // Return formatted string.
        return formatter.string(from: date)
    }
    
    /// Provides the hour and minute components for the stored time.
    var dateComponents: DateComponents {
        // Prepare calendar.
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = .gmt // We use GMT+0 since timeIntervalSince1970 is initialized relative to 00:00:00 UTC.
        
        let date = Date(timeIntervalSince1970: TimeInterval(secondsSinceMidnight))
        
        // Create and return components.
        return utcCalendar.dateComponents([.hour, .minute], from: date)
    }
}

