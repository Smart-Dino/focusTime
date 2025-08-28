//
//  File.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 25.07.2025.
//

import Combine
import SwiftUI

@Observable
public final class FTTimerPayload {
    public private(set) var hours: Int
    public private(set) var minutes: Int
    public private(set) var seconds: Int
    public private(set) var formatted: String
    
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
    
    public func setHours(_ hours: Int) {
        self.hours = hours
    }
    
    public func setMinutes(_ minutes: Int) {
        self.minutes = minutes
    }
    
    public func setSeconds(_ seconds: Int) {
        self.seconds = seconds
    }
    
    public func setFormatted(_ formatted: String) {
        self.formatted = formatted
    }
}

@MainActor
public protocol FTTimer: AnyObject {
    var payload: FTTimerPayload { get }
    var isPaused: Bool { get }
    var isRunning: Bool { get }
    
    func start(deadline: Date, isInitiallyPaused: Bool)
    func pause()
    func resume()
    func cancel()
}
