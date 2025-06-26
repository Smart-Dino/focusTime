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
struct TimeComponents: Codable {
    private let timeSince1970: Int

    init?(secondsSince1970: Int) {
        self.timeSince1970 = secondsSince1970
    }
    
    init?(hour: Int, minute: Int) {
        guard (0..<24).contains(hour), (0..<60).contains(minute) else { return nil }
        let hoursAsSeconds = hour * 60 * 60
        let minutesAsSeconds = minute * 60
        let totalSeconds = hoursAsSeconds + minutesAsSeconds
        self.timeSince1970 = totalSeconds
    }

    /// Returns time in "HH:mm" format (e.g. "08:30").
    var description: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeSince1970))
        let formatted = date.formatted(date: .omitted, time: .shortened)
        return formatted
    }
    
    var dateComponents: DateComponents {
        let date = Date(timeIntervalSince1970: TimeInterval(timeSince1970))
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        return components
    }
}
