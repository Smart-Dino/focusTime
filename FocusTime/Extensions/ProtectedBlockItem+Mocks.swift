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
        type: .duration(duration: .init(seconds: 120)),
        blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
    )
    
    static let `default` = Self.init(
        emoji: FocusPreset.allCases.first?.emoji ?? "☀️",
        name: String(
            localized: "Focus Session",
            table: "SessionLocalizable"
        ),
        days: Set(Weekday.allCases),
        type: .duration(duration: .init(hour: 0, minute: 30)),
        blockedContent: ProtectedActivitySelection(FamilyActivitySelection())
    )
}
