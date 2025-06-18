//
//  Schedule.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import Foundation
import SwiftData

// An enum to represent the days of the week for scheduling.
enum Weekday: Int, Codable, CaseIterable, Comparable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    // Replace alphabetic sort with the right one.
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// Had to create my own because SwiftData does not like DateComponents
// Fatal error: Unexpected property within Persisted Struct/Enum: _CalendarProtocol
// https://fatbobman.com/en/posts/considerations-for-using-codable-and-enums-in-swiftdata-models/#:~:text=Such%20errors%20indicate,of%20the%20model.
struct TimeComponents: Codable {
    let hour: Int
    let minute: Int
    
    init?(hour: Int, minute: Int) {
        guard (0..<24).contains(hour), (0..<60).contains(minute) else { return nil }
        self.hour = hour
        self.minute = minute
    }
}

@Model
final class Schedule: SwiftDataItem {
    
    @Attribute(.unique) var id: UUID
    var days: Set<Weekday>
    var startTime: TimeComponents
    var endTime: TimeComponents
    var isActive: Bool
    
    @Relationship(inverse: \BlockItem.schedules)
    var blockItems: [BlockItem]
    
    init(
        id: UUID = UUID(),
        days: Set<Weekday>,
        startTime: TimeComponents,
        endTime: TimeComponents,
        isActive: Bool,
        blockItems: [BlockItem]
    ) {
        self.id = id
        self.days = days
        self.startTime = startTime
        self.endTime = endTime
        self.isActive = isActive
        self.blockItems = blockItems
    }
}
