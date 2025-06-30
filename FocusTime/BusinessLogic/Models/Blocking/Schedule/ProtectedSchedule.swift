//
//  ProtectedSchedule.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.06.2025.
//

import Foundation

struct ProtectedSchedule: Sendable {
    let id: UUID
    let emoji: String
    let name: String
    let days: Set<Weekday>
    let startTime: TimeComponents
    let endTime: TimeComponents

    init(
        id: UUID = UUID(),
        emoji: String,
        name: String,
        days: Set<Weekday>,
        startTime: TimeComponents,
        endTime: TimeComponents,
    ) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.days = days
        self.startTime = startTime
        self.endTime = endTime
    }
}
