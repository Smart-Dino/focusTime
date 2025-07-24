//
//  ScheduleType.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.07.2025.
//

import Foundation

enum ScheduleType: Codable, Hashable {
    case scheduled(startTime: TimeComponents, endTime: TimeComponents)
    case oneTime(_ duration: DurationComponents) // Duration, expressed in seconds.
    
    var description: String {
        switch self {
        case .scheduled(let startTime, let endTime):
            startTime.description + " " + endTime.description
        case .oneTime(let duration):
            PeriodConverter.localizedConciseTimeString(from: duration.rawValue)
        }
    }
}
