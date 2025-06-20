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
    let hour: Int
    let minute: Int

    init?(hour: Int, minute: Int) {
        guard (0..<24).contains(hour), (0..<60).contains(minute) else { return nil }
        self.hour = hour
        self.minute = minute
    }

    /// Returns time in "HH:mm" format (e.g. "08:30").
    var description: String {
        String(format: "%02d:%02d", hour, minute)
    }

    /// Optionally returns time in user's locale using DateFormatter
    func localizedDescription(using calendar: Calendar = .current, locale: Locale = .current) -> String {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        formatter.timeStyle = .short

        return formatter.string(from: calendar.date(from: components)!)
    }
}
