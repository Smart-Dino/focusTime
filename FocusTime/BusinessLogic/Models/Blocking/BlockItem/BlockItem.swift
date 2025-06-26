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
final class BlockItem: SwiftDataItem {
    // MARK: - Saved properties
    @Attribute(.unique) var id: UUID
    var name: String
    var emoji: String
    var schedules: [Schedule]?
    var blockedContent: FamilyActivitySelection
    // MARK: - Computed properties
    var schedulesDescription: String {
        guard let schedules, schedules.count >= 1 else { return "No schedules" }
        
        if schedules.count == 1 {
            guard let first = schedules.first else { return "No schedules" }
            return "\(first.daysDescription), \(first.startTime.description) – \(first.endTime.description)"
        } else {
            return "\(schedules.count) schedules"
        }
    }

    
    init(id: UUID = UUID(),
         name: String,
         emoji: String,
         schedules: [Schedule] = [],
         blockedContent: FamilyActivitySelection,
         isEnabled: Bool = true) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.schedules = schedules
        self.blockedContent = blockedContent
    }
    
    convenience init(from item: ProtectedBlockItem) {
        self.init(id: item.id,
                  name: item.name,
                  emoji: item.emoji,
                  schedules: [],
                  blockedContent: item.blockedContent)
    }
}
