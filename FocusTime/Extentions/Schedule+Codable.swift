////
////  ScheduleCodable.swift
////  FocusTime
////
////  Created by Maksym Horobets on 18.06.2025.
////
//
//import Foundation
//
//extension Schedule {
//    enum CodingKeys: CodingKey {
//        case id, emoji, name, days, startTime, endTime, blockItem
//    }
//}
//
//extension Schedule: Codable {
//    func encode(to encoder: any Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(emoji, forKey: .emoji)
//        try container.encode(name, forKey: .name)
//        try container.encode(days, forKey: .days)
//        try container.encode(startTime, forKey: .startTime)
//        try container.encode(endTime, forKey: .endTime)
//        try container.encode(blockItems, forKey: .blockItem)
//    }
//    
//    convenience init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let id = try container.decode(UUID.self, forKey: .id)
//        let emoji = try container.decode(String.self, forKey: .emoji)
//        let name = try container.decode(String.self, forKey: .name)
//        let days = try container.decode(Set<Weekday>.self, forKey: .days)
//        let startTime = try container.decode(TimeComponents.self, forKey: .startTime)
//        let endTime = try container.decode(TimeComponents.self, forKey: .endTime)
//        let blockItems = try container.decode([BlockItem].self, forKey: .blockItem)
//        
//        self.init(
//            id: id,
//            emoji: emoji,
//            name: name,
//            days: days,
//            startTime: startTime,
//            endTime: endTime,
//            blockItems: blockItems
//        )
//    }
//}
