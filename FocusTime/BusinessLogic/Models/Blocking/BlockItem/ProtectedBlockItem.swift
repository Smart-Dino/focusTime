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
    
    let emoji: String
    let name: String
    let blockedContent: ProtectedActivitySelection
    
    let schedulesDescription: String

    init(
        id: UUID = UUID(),
        persistentModelID: PersistentIdentifier? = nil,
        emoji: String,
        name: String,
        blockedContent: ProtectedActivitySelection,
        schedulesDescription: String = "No schedules"
    ) {
        self.id = id
        self.persistentModelID = persistentModelID
        self.emoji = emoji
        self.name = name
        self.blockedContent = blockedContent
        self.schedulesDescription = schedulesDescription
    }
    
    init(from item: BlockItem) {
        self.init(id: item.id,
                  persistentModelID: item.persistentModelID,
                  emoji: item.emoji,
                  name: item.name,
                  blockedContent: item.blockedContent,
                  schedulesDescription: item.schedulesDescription)
    }
}
