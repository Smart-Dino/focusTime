//
//  BlockItemModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import Foundation
import SwiftData
import FamilyControls

@Model
final class BlockItem {
    // Brought back the custom identifier for easier access across targets.
    var id: UUID
    var name: String
    var emoji: String
    // Schedule.
    var days: Set<Weekday>
    var type: ScheduleType
    // Blocked apps.
    var blockedContent: ProtectedActivitySelection
    
    init(
        id: UUID = UUID(),
        name: String,
        emoji: String,
        days: Set<Weekday>,
        type: ScheduleType,
        blockedContent: ProtectedActivitySelection
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.days = days
        self.type = type
        self.blockedContent = blockedContent
    }
    
    convenience init(from item: ProtectedBlockItem) {
        self.init(
            id: item.id,
            name: item.name,
            emoji: item.emoji,
            days: item.days,
            type: item.type,
            blockedContent: item.blockedContent
        )
    }
}
