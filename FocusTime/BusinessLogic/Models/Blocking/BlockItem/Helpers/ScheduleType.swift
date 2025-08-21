//
//  ScheduleType.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.07.2025.
//

import Foundation

enum ScheduleType: Codable, Hashable {
    case scheduled(startTime: TimeComponents, endTime: TimeComponents)
    case duration(_ duration: DurationComponents,
                 // Suspension helper properties.
                 startedAt: Date?,
                 suspendedAt: Date?,
                 timeLeft: DurationComponents)
    
    var description: String {
        switch self {
        case .scheduled(let startTime, let endTime):
            startTime.description + " " + endTime.description
        case .duration(let duration, _, _, _):
            PeriodConverter.localizedConciseTimeString(from: duration.rawValue)
        }
    }
    
    static func duration(_ duration: DurationComponents,
                        startedAt: Date? = nil,
                        suspendedAt: Date? = nil,
                        timeLeft: DurationComponents? = nil) -> ScheduleType {
        return .duration(duration,
                        startedAt: startedAt,
                        suspendedAt: suspendedAt,
                        timeLeft: timeLeft ?? duration)
    }
    
    var secondsToIntervalEndIfShouldBeRunning: Int? {
        secondsToIntervalEndIfShouldBeRunning(now: .now)
    }
    
    func secondsToIntervalEndIfShouldBeRunning(now: Date) -> Int? {
        switch self {
        case .scheduled(let startTime, let endTime):
            guard let currentTimeComponent = try? TimeComponents(from: now) else { return nil }
            
            let timeSinceStart = currentTimeComponent.localizedSecondsSinceMidnight - startTime.localizedSecondsSinceMidnight
            let timeLeftInSeconds = endTime.localizedSecondsSinceMidnight - currentTimeComponent.localizedSecondsSinceMidnight
            
            if timeLeftInSeconds > 60 && timeSinceStart > 0 {
                return timeLeftInSeconds
            } else {
                return nil
            }
        case .duration(let initialDuration, let startedAt, let suspendedAt, let timeLeft):
            guard let startedAt else { return nil }

            let durationInSeconds = initialDuration.rawValue
            let timeLeftInSeconds = timeLeft.rawValue

            // If it's suspended, timeLeft is the actual value
            if suspendedAt != nil {
                return timeLeftInSeconds > 0 ? timeLeftInSeconds : nil
            }

            // If not suspended, subtract elapsed time from the original duration
            let elapsed = now.timeIntervalSince(startedAt)
            let remaining = Int(durationInSeconds - Int(elapsed))

            return remaining
        }
    }
}
