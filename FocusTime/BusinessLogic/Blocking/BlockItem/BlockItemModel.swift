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
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: String
    var schedules: [Schedule]
    var blockedContent: FamilyActivitySelection
    
    var isEnabled: Bool = true // Shows whether the block is currently in action.
    
    init(id: UUID = UUID(),
         name: String,
         icon: String,
         schedules: [Schedule] = [],
         blockedContent: FamilyActivitySelection,
         isEnabled: Bool = true) {
        self.id = id
        self.name = name
        self.icon = icon
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
