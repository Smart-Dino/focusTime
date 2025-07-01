//
//  ProtectedBlockItem.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.06.2025.
//

import Foundation
#warning("@preconcurrency import")
@preconcurrency import FamilyControls

struct ProtectedBlockItem: Sendable {
    let id: UUID
    let emoji: String
    let name: String
    let blockedContent: FamilyActivitySelection

    init(
        id: UUID = UUID(),
        emoji: String,
        name: String,
        blockedContent: FamilyActivitySelection,
    ) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.blockedContent = blockedContent
    }
}
