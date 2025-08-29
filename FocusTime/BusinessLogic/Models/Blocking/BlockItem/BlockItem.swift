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
    
    var isTemporary: TempMode? // Signals whether this item will have to be removed after use.
    var isCancelled: Bool
    // Blocked apps.
    var blockedContent: FamilyActivitySelection
    
    var state: BlockState {
        switch type {
        case let .scheduled(_, _, isActive, isPaused, suspendedUntil):
            switch (isPaused, suspendedUntil, isActive) {
            case (true, .some, _):    return .suspended
            case (true, .none, _):    return .suspendedIndefinitely
            case (_, _, true):        return .running
            default:                  return .inactive
            }

        case let .duration(_, suspendedAt, suspendedUntil, endDate):
            switch (suspendedAt, suspendedUntil, endDate) {
            case (.some, .some, _):   return .suspended
            case (.some, .none, _):   return .suspendedIndefinitely
            case (_, _, .some):       return .running
            default:                  return .inactive
            }
        }
    }

    init(
        id: UUID = UUID(),
        name: String,
        emoji: String,
        days: Set<Weekday>,
        type: ScheduleType,
        isTemporary: TempMode? = nil,
        isCancelled: Bool = false,
        blockedContent: FamilyActivitySelection
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.days = days
        self.type = type
        self.isTemporary = isTemporary
        self.isCancelled = isCancelled
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
            isCancelled: item.isCancelled,
            blockedContent: item.blockedContent
        )
    }
}
