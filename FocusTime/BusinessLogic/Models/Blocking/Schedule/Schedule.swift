//
//  Schedule.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import Foundation
import SwiftData

@Model
final class Schedule {
    // Brought back the custom identifier for easier access across targets.
    var id: UUID
    var emoji: String
    var name: String
    var days: Set<Weekday>
    var type: ScheduleType
    // I think we don't need isActive property,
    // since we can just query the DeviceActivityCenter
    // for active schedules.
    
    // MARK: Relationship
    @Relationship(deleteRule: .nullify, inverse: \BlockItem.schedules)
    var blockItems: [BlockItem]?
    
    init(
        id: UUID = UUID(),
        emoji: String,
        name: String,
        days: Set<Weekday>,
        type: ScheduleType,
        blockItems: [BlockItem]? = nil
    ) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.days = days
        self.type = type
        self.blockItems = blockItems
    }
    
    convenience init(from item: ProtectedSchedule) {
        self.init(emoji: item.emoji,
                  name: item.name,
                  days: item.days,
                  type: item.type)
    }
}

