//
//  ProtectedBlockItem.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.06.2025.
//

import Foundation
import SwiftData
import FamilyControls

struct ProtectedBlockItem: ProtectedModel {
    
    var id: UUID
    let persistentModelID: PersistentIdentifier?
    
    var emoji: String
    var name: String
    var days: Set<Weekday>
    var type: ScheduleType
    var isTemporary: Bool
    var blockedContent: ProtectedActivitySelection
    
    init(
        id: UUID = UUID(),
        persistentModelID: PersistentIdentifier? = nil,
        emoji: String,
        name: String,
        days: Set<Weekday>,
        type: ScheduleType,
        isTemporary: Bool = false,
        blockedContent: ProtectedActivitySelection
    ) {
        self.id = id
        self.persistentModelID = persistentModelID
        self.emoji = emoji
        self.name = name
        self.days = days
        self.type = type
        self.isTemporary = isTemporary
        self.blockedContent = blockedContent
    }
    
    init(from item: BlockItem) {
        self.init(
            id: item.id,
            persistentModelID: item.persistentModelID,
            emoji: item.emoji,
            name: item.name,
            days: item.days,
            type: item.type,
            isTemporary: item.isTemporary,
            blockedContent: item.blockedContent
        )
    }
}
