//
//  Clock.swift
//  FocusTime
//
//  Created by Maksym Horobets on 28.07.2025.
//

import Foundation

protocol Clock: Actor {
    var now: Date { get }
}
