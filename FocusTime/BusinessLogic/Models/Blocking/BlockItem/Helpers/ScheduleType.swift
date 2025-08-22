//
//  ScheduleType.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.07.2025.
//

import Foundation

enum ScheduleType: Codable, Hashable, Equatable {
    case scheduled(
        startTime: TimeComponents,
        endTime: TimeComponents,
        isActive: Bool = false,
        isPaused: Bool = false,
        suspendedUntil: Date? = nil
    )
    case duration(
        duration: DurationComponents,
        // Suspension helper properties.
        suspendedAt: Date? = nil,
        suspendedUntil: Date? = nil,
        endDate: Date? = nil
    )
    
    var description: String {
        switch self {
        case .scheduled(let startTime, let endTime, _, _, _):
            startTime.description + " - " + endTime.description
        case .duration(let duration, _, _, _):
            PeriodConverter.localizedConciseTimeString(
                from: duration.rawValue,
                allowedUnits: [.hour, .minute],
                unitsStyle: .abbreviated
            )
        }
    }
    
    var suspensionEndDate: Date? {
        switch self {
        case .duration(_, _, let suspendedUntil, _): suspendedUntil
        case .scheduled(_, _, _, _, let suspendedUntil): suspendedUntil
        }
    }
    
    func secondsToIntervalEndIfShouldBeRunning(now: Date = .now) -> Int? {
        switch self {
        case .scheduled(let startTime, let endTime, _, _, _):
            let currentSecondsFromMidnight = Date.secondsSinceMidnight(now: now)
            
            let timeSinceStart = currentSecondsFromMidnight - startTime.localizedSecondsSinceMidnight
            let timeLeftInSeconds = endTime.localizedSecondsSinceMidnight - currentSecondsFromMidnight
            
            if timeSinceStart >= 0 {
                return timeLeftInSeconds
            } else {
                return nil
            }
            
        case .duration(_, let suspendedAt, _, let endDate):
            // If there's no endDate, duration isn't running.
            guard let endDate else { return nil }
            
            if let suspendedAt {
                // If suspended, freeze remaining seconds as of suspension time.
                let remainingAtSuspension = max(0, Int(endDate.timeIntervalSince(suspendedAt)))
                return remainingAtSuspension
            } else {
                // Not suspended — remaining is based on "now".
                let remaining = max(0, Int(endDate.timeIntervalSince(now)))
                return remaining
            }
        }
    }
    
}
