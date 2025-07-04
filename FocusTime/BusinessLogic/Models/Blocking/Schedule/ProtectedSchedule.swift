//
//  ProtectedSchedule.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.06.2025.
//

import SwiftData
import Foundation

struct ProtectedSchedule: ProtectedModel {
    
    var persistentModelID: PersistentIdentifier?
    
    let emoji: String
    let name: String
    let days: Set<Weekday>
    let startTime: TimeComponents
    let endTime: TimeComponents
    
    var daysDescription: String

    init(
        persistentModelID: PersistentIdentifier? = nil,
        emoji: String,
        name: String,
        days: Set<Weekday>,
        startTime: TimeComponents,
        endTime: TimeComponents,
        daysDescription: String = "0 days"
    ) {
        self.persistentModelID = persistentModelID
        self.emoji = emoji
        self.name = name
        self.days = days
        self.startTime = startTime
        self.endTime = endTime
        self.daysDescription = daysDescription
    }
    
    init(from item: Schedule) {
        self.init(persistentModelID: item.persistentModelID,
                  emoji: item.emoji,
                  name: item.name,
                  days: item.days,
                  startTime: item.startTime,
                  endTime: item.endTime
        )
    }
}
