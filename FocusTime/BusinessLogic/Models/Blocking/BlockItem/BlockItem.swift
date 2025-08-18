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
    var isTemporary: Bool // Signals whether this item will have to be removed after use.
    // Blocked apps.
    var blockedContent: ProtectedActivitySelection
    
    var isActive: Bool {
        switch type {
        case .scheduled(_, _, let isActive, _):
            isActive
        case .duration(_, _, _, let endDate):
            endDate != nil
        }
    }
    
    var isPaused: Bool {
        switch type {
        case .scheduled(_, _, _, let isPaused):
            isPaused
        case .duration(_, let suspendedAt, _, _):
            suspendedAt != nil
        }
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        emoji: String,
        days: Set<Weekday>,
        type: ScheduleType,
        isTemporary: Bool = false,
        blockedContent: ProtectedActivitySelection
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.days = days
        self.type = type
        self.isTemporary = isTemporary
        self.blockedContent = blockedContent
    }
    
    convenience init(from item: ProtectedBlockItem) {
        self.init(
            id: item.id,
            name: item.name,
            emoji: item.emoji,
            days: item.days,
            type: item.type,
            isTemporary: item.isTemporary,
            blockedContent: item.blockedContent
        )
    }
}
