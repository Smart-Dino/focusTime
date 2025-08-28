//
//  ProtectedBlockItem+Mocks.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.08.2025.
//

import Foundation
import FamilyControls

extension ProtectedBlockItem {
    static var mockDuration: ProtectedBlockItem {
        Self(
            emoji: "🧪",
            name: "Test",
            days: Weekday.weekdays,
            type: .duration(duration: .init(seconds: 120)),
            blockedContent: FamilyActivitySelection()
        )
    }
    
    static var mockScheduled: ProtectedBlockItem {
        Self(
            emoji: "🧪",
            name: "Test",
            days: Weekday.weekdays,
            type: .scheduled(
                startTime: try! .init(hour: 1, minute: 0),
                endTime: try! .init(hour: 2, minute: 0),
                isActive: false,
                isPaused: false,
                suspendedUntil: nil
            ),
            blockedContent: FamilyActivitySelection()
        )
    }
    
    static var `default`: ProtectedBlockItem {
        Self(
            emoji: FocusPreset.allCases.first?.emoji ?? "☀️",
            name: String(
                localized: "focus_session_default_name",
                table: "SessionLocalizable"
            ),
            days: Set(Weekday.allCases),
            type: .duration(duration: .init(hour: 0, minute: 30)),
            blockedContent: FamilyActivitySelection()
        )
    }
}
