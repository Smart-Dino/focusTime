//
//  TestClock.swift
//  FocusTime
//
//  Created by Maksym Horobets on 28.07.2025.
//

import Foundation

actor TestClock: Clock {
    private(set) var currentDate: Date

    init(startingAt date: Date) { self.currentDate = date }

    var now: Date { currentDate }

    func advance(by interval: TimeInterval) {
        currentDate = currentDate.addingTimeInterval(interval)
    }
}
