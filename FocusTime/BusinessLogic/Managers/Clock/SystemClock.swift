//
//  SystemClock.swift
//  FocusTime
//
//  Created by Maksym Horobets on 28.07.2025.
//

import Foundation

actor SystemClock: Clock {
    var now: Date { Date.now }
}
