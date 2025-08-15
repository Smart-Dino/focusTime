//
//  ProtectedBlockItem+Mocks.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.08.2025.
//

import Foundation
import FamilyControls

extension ProtectedBlockItem {
    static let mock = Self.init(
        emoji: "🧪",
        name: "Test",
        days: Weekday.weekdays,
        type: .duration(.init(duration: 120)),
        blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
    )
}
