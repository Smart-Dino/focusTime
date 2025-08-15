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
}
