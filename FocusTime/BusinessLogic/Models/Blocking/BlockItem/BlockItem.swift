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
    // MARK: - Dynamic
    var isEnabled: Bool = true // Shows whether the block is currently in action.
    // MARK: - Computed properties
    var schedulesDescription: String {
        guard let schedules, schedules.count >= 1 else { return "No schedules" }
        
        if schedules.count == 1 {
            guard let first = schedules.first else { return "No schedules" }
            return "\(first.days.daysDescription), \(first.startTime.localizedDescription()) – \(first.endTime.localizedDescription())"
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
        self.isEnabled = isEnabled
    }
}

extension BlockItem {
//    @MainActor
//    static let mocks: [BlockItem] = [
//        BlockItem.init(
//            name: "Default",
//            icon: "🛑",
//            schedule: .init(days: [.monday],
//                            startTime: DateComponents(hour: 17, minute: 00),
//                            endTime: DateComponents(hour: 19, minute: 00)),
//            blockedContent: FamilyActivitySelection(),
//            isScheduled: false,
//            isEnabled: false
//        )
//    ]
}
