//
//  Schedule.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import Foundation
import SwiftData

@Model
final class Schedule: SwiftDataItem {
    
    @Attribute(.unique) var id: UUID
    var emoji: String
    var name: String
    var days: Set<Weekday>
    var startTime: TimeComponents
    var endTime: TimeComponents
    var isActive: Bool
    
    @Relationship(deleteRule: .nullify, inverse: \BlockItem.schedules)
    var blockItems: [BlockItem]?
    
    /// Returns a user-friendly description for a set of weekdays.
    var daysDescription: String {
        switch days {
        case Set(Weekday.allCases.filter({ !$0.isWorkDay })): "Weekend"
        case Weekday.weekdays:               "Weekdays"
        case Set(Weekday.allCases):          "Every day"
        case let days where days.count == 1: days.first!.description
        default:                             "\(self.count) days"
        }
    }
    
    init(
        id: UUID = UUID(),
        emoji: String,
        name: String,
        days: Set<Weekday>,
        startTime: TimeComponents,
        endTime: TimeComponents,
        isActive: Bool,
        blockItems: [BlockItem] = []
    ) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.days = days
        self.startTime = startTime
        self.endTime = endTime
        self.isActive = isActive
        self.blockItems = blockItems
    }
}
