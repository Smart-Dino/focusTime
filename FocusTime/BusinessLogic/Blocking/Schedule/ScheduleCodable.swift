//
//  ScheduleCodable.swift
//  FocusTime
//
//  Created by Maksym Horobets on 18.06.2025.
//

import Foundation

extension Schedule {
    enum CodingKeys: CodingKey {
        case days, startTime, endTime, isActive, blockItem
    }
}

extension Schedule: Codable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(days, forKey: .days)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(blockItems, forKey: .blockItem)
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let days = try container.decode(Set<Weekday>.self, forKey: .days)
        let startTime = try container.decode(TimeComponents.self, forKey: .startTime)
        let endTime = try container.decode(TimeComponents.self, forKey: .endTime)
        let isActive = try container.decode(Bool.self, forKey: .isActive)
        let blockItems = try container.decode([BlockItem].self, forKey: .blockItem)
        
        self.init(
            days: days,
            startTime: startTime,
            endTime: endTime,
            isActive: isActive,
            blockItems: blockItems
        )
    }
}
