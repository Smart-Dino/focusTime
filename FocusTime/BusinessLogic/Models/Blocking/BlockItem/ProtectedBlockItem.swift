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
    var isScheduled: Bool
    var blockedContent: ProtectedActivitySelection
    
    var isActive: Bool {
        switch type {
        case .scheduled(_, _, let isActive, _):
            isActive
        case .duration(_, let suspendedAt, _, let endDate):
            (endDate != nil) || (suspendedAt != nil)
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
        persistentModelID: PersistentIdentifier? = nil,
        emoji: String,
        name: String,
        days: Set<Weekday>,
        type: ScheduleType,
        isTemporary: Bool = false,
        isScheduled: Bool = false,
        blockedContent: ProtectedActivitySelection
    ) {
        self.id = id
        self.persistentModelID = persistentModelID
        self.emoji = emoji
        self.name = name
        self.days = days
        self.type = type
        self.isTemporary = isTemporary
        self.isScheduled = isScheduled
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
