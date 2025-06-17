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
    var id: UUID
    var name: String
    var icon: String
    var schedule: Schedule?
    var blockedContent: FamilyActivitySelection
    
    var isScheduled: Bool      // Shows whether the block is scheduled to run in.
    var isEnabled: Bool = true // Shows whether the block is currently in action.
    
    /// Example initializer.
    init(id: UUID = UUID(),
         name: String,
         icon: String,
         schedule: Schedule? = nil,
         blockedContent: FamilyActivitySelection,
         isScheduled: Bool,
         isEnabled: Bool = true) {
        self.id = id
        self.name = name
        self.icon = icon
//        // Ensure schedule is only set if isScheduled is true
//        self.schedule = isScheduled ? schedule : nil
        self.schedule = schedule
        self.blockedContent = blockedContent
        self.isScheduled = isScheduled
        self.isEnabled = isEnabled
    }
}

extension BlockItem {
    @MainActor
    static let mocks: [BlockItem] = [
        BlockItem.init(
            name: "Default",
            icon: "🛑",
            schedule: .init(days: [.monday],
                            startTime: DateComponents(hour: 17, minute: 00),
                            endTime: DateComponents(hour: 19, minute: 00)),
            blockedContent: FamilyActivitySelection(),
            isScheduled: false,
            isEnabled: false
        )
    ]
}
