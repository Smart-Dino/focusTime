//
//  ProtectedBlockItem.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.06.2025.
//

import Foundation
import SwiftData
import FamilyControls

struct ProtectedBlockItem: ProtectedModel, Hashable, Equatable {
    
    var id: UUID
    let persistentModelID: PersistentIdentifier?
    
    var emoji: String
    var name: String
    var days: Set<Weekday>
    var type: ScheduleType
    
    var isTemporary: Bool
    var isCancelled: Bool
    
    var isScheduled: Bool
    var blockedContent: ProtectedActivitySelection
    
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
        persistentModelID: PersistentIdentifier? = nil,
        emoji: String,
        name: String,
        days: Set<Weekday>,
        type: ScheduleType,
        isTemporary: Bool = false,
        isCancelled: Bool = false,
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
        self.isCancelled = isCancelled
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
            isCancelled: item.isCancelled,
            blockedContent: item.blockedContent
        )
    }
}
