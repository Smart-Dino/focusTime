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
                 endDate: Date) // absolute Date representing supposed end-time
    
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
                         endDate: Date? = nil) -> ScheduleType {
        // If caller provides explicit end Date, use it.
        // Otherwise, compute end Date from startedAt (if present) or now.
        let start = startedAt ?? Date()
        let computedEnd = endDate ?? start.addingTimeInterval(TimeInterval(duration.rawValue))
        return .duration(duration,
                         startedAt: startedAt,
                         suspendedAt: suspendedAt,
                         endDate: computedEnd)
    }
    
    func secondsToIntervalEndIfShouldBeRunning(now: Date = .now) -> Int? {
        switch self {
        case .scheduled(let startTime, let endTime, let isActive):
            guard isActive != false else { return nil }
            
            let currentSecondsFromMidnight = Date.secondsSinceMidnight(now: now)
            
            let timeSinceStart = currentSecondsFromMidnight - startTime.localizedSecondsSinceMidnight
            let timeLeftInSeconds = endTime.localizedSecondsSinceMidnight - currentSecondsFromMidnight
            
            if timeSinceStart >= 0 {
                return timeLeftInSeconds
            } else {
                return nil
            }
            
        case .duration(_, let startedAt, let suspendedAt, let endDate):
            // If there's no startedAt, duration isn't running.
            guard let _ = startedAt else { return nil }
            
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
