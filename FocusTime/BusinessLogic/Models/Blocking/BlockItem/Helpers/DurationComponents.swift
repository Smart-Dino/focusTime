//
//  DurationComponents.swift
//  FocusTime
//
//  Created by Maksym Horobets on 24.07.2025.
//

import Foundation

/// Represents a duration in hours and minutes, stored as seconds.
struct DurationComponents: Equatable, Codable, Hashable {
    private let secondsSinceMidnight: Int
    
    /// Provides the hour and minute components for the stored duration.
    var dateComponents: DateComponents {
        // Prepare calendar.
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = .gmt // We use GMT+0 since timeIntervalSince1970 is initialized relative to 00:00:00 UTC.
        
        let date = Date(timeIntervalSince1970: TimeInterval(secondsSinceMidnight))
        
        // Create and return components.
        return utcCalendar.dateComponents([.hour, .minute], from: date)
    }
    
    /// Abbreviated description of the length of component in hours and minutes.
    var description: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: dateComponents) ?? "-"
    }
    
    /// Returns the raw seconds value (alias for duration).
    var rawValue: Int { secondsSinceMidnight }
    
    /// Initializes with hour and minute components.
    /// - Parameters:
    ///   - hour: Hour value.
    ///   - minute: Minute value.
    init(hour: Int, minute: Int) {
        let hoursAsSeconds = hour * 60 * 60
        let minutesAsSeconds = minute * 60
        let totalSeconds = hoursAsSeconds + minutesAsSeconds
        self.secondsSinceMidnight = totalSeconds
    }
    
    /// Initializes with a duration in seconds.
    init(duration: Int) {
        self.secondsSinceMidnight = duration
    }
}
