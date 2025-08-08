//
//  ScheduleType.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.07.2025.
//

import Foundation

enum ScheduleType: Codable, Hashable {
    case scheduled(startTime: TimeComponents, endTime: TimeComponents, isActive: Bool = false)
    case duration(_ duration: DurationComponents,
                 // Suspension helper properties.
                 startedAt: Date?,
                 suspendedAt: Date?,
                 timeLeft: DurationComponents)
    
    var description: String {
        switch self {
        case .scheduled(let startTime, let endTime, _):
            startTime.description + " - " + endTime.description
        case .duration(let duration, _, _, _):
            PeriodConverter.localizedConciseTimeString(
                from: duration.rawValue,
                allowedUnits: [.hour, .minute],
                unitsStyle: .abbreviated
            )
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
    
    func secondsToIntervalEndIfShouldBeRunning(now: Date = .now) -> Int? {
        switch self {
        case .scheduled(let startTime, let endTime, let isActive):
            guard isActive != false, let currentTimeComponent = try? TimeComponents(from: now) else { return nil }
            
            let timeSinceStart = currentTimeComponent.localizedSecondsSinceMidnight - startTime.localizedSecondsSinceMidnight
            let timeLeftInSeconds = endTime.localizedSecondsSinceMidnight - currentTimeComponent.localizedSecondsSinceMidnight
            
            if timeSinceStart > 0 {
                return timeLeftInSeconds
            } else {
                return nil
            }
        case .duration(_, let startedAt, let suspendedAt, let timeLeft):
            guard startedAt != nil else { return nil }

            let timeLeftInSeconds = timeLeft.rawValue

            // If it's suspended, show seconds to next minute boundary or full minute if exactly on the minute.
            if suspendedAt != nil {
                let secondsToNextMinute = timeLeftInSeconds % 60 == 0 ? 60 : timeLeftInSeconds % 60
                return secondsToNextMinute
            }

            // If not suspended, return seconds to the next full minute mark from 'now'.
            let seconds = Calendar.current.component(.second, from: now)
            let secondsToNextMinute = 60 - seconds
            return secondsToNextMinute
        }
    }
}

