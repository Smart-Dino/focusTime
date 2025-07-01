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
    let emoji: String
    let name: String
    let blockedContent: FamilyActivitySelection

    init(
        emoji: String,
        name: String,
        blockedContent: FamilyActivitySelection,
    ) {
        self.emoji = emoji
        self.name = name
        self.blockedContent = blockedContent
    }
}
