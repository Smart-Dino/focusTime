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
    
    @Relationship(inverse: \BlockItem.schedules)
    var blockItems: [BlockItem]
    
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
