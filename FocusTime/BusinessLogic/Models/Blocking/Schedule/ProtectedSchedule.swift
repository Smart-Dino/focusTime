//
//  ProtectedSchedule.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.06.2025.
//

import SwiftData
import Foundation

struct ProtectedSchedule: ProtectedModel {
    
    let id: UUID
    let persistentModelID: PersistentIdentifier?
    
    var emoji: String
    var name: String
    var days: Set<Weekday>
    var type: ScheduleType

    init(
        id: UUID = UUID(),
        persistentModelID: PersistentIdentifier? = nil,
        emoji: String,
        name: String,
        days: Set<Weekday>,
        type: ScheduleType,
    ) {
        self.id = id
        self.persistentModelID = persistentModelID
        self.emoji = emoji
        self.name = name
        self.days = days
        self.type = type
    }
    
    init(from item: Schedule) {
        self.init(id: item.id,
                  persistentModelID: item.persistentModelID,
                  emoji: item.emoji,
                  name: item.name,
                  days: item.days,
                  type: item.type)
    }
}
