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
    var blockedContent: ProtectedActivitySelection
    
    // MARK: Relationship
    var schedules: [Schedule]?
    
    // MARK: - Computed properties
    var schedulesDescription: String {
        guard let schedules, schedules.count >= 1 else { return "No schedules" }
        
        if schedules.count == 1 {
            guard let first = schedules.first else { return "No schedules" }
            return "\(first.days.description), \(first.type.description)"
        } else {
            return "\(schedules.count) schedules"
        }
    }
    
    
    init(
        id: UUID = UUID(),
        name: String,
        emoji: String,
        blockedContent: ProtectedActivitySelection,
        schedules: [Schedule]? = nil
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.blockedContent = blockedContent
        self.schedules = schedules
    }
    
    convenience init(from item: ProtectedBlockItem) {
        self.init(id: item.id,
                  name: item.name,
                  emoji: item.emoji,
                  blockedContent: item.blockedContent)
    }
}
