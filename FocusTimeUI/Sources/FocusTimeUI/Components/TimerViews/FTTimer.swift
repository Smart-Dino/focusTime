//
//  File.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 25.07.2025.
//

import Combine
import SwiftUI

public struct FTTimerPayload {
    public var hours: Int
    public var minutes: Int
    public var seconds: Int
    public var formatted: String
    
    public init(
        hours: Int = 0,
        minutes: Int = 0,
        seconds: Int = 0,
        formatted: String = .init()
    ) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.formatted = formatted
    }
}

@MainActor
public protocol FTTimer: AnyObject, Observable {
    var payload: FTTimerPayload { get }
    var isPaused: Bool { get }
    var isRunning: Bool { get }
    
    func setHours(_ hours: Int)
    func setMinutes(_ minutes: Int)
    func setSeconds(_ seconds: Int)
    
    func start(deadline: Date, isInitiallyPaused: Bool)
    func pause()
    func resume()
    func cancel()
}
