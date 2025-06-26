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
    let name: String
    let emoji: String
    let blockedContent: FamilyActivitySelection

    init(
        id: UUID = UUID(),
        name: String,
        emoji: String,
        blockedContent: FamilyActivitySelection,
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.blockedContent = blockedContent
    }
}
