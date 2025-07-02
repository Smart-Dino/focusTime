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
    // Removed id because each Model instance gets a PersistenceIdentifier by default.
    var name: String
    var emoji: String
    var blockedContent: FamilyActivitySelection
    
    // MARK: Relationship
    var schedules: [Schedule]?
    
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
    
    
    init(
        name: String,
        emoji: String,
        blockedContent: FamilyActivitySelection,
        schedules: [Schedule]? = nil
    ) {
        self.name = name
        self.emoji = emoji
        self.blockedContent = blockedContent
        self.schedules = schedules
    }
    
    convenience init(from item: ProtectedBlockItem) {
        self.init(name: item.name,
                  emoji: item.emoji,
                  blockedContent: item.blockedContent)
    }
    
    func appendSchedule(_ item: Schedule) {
        if schedules == nil {
            schedules = []
        }
        schedules!.append(item)
    }
}
