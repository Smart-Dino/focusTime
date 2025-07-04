////
////  BlockItemCodable.swift
////  FocusTime
////
////  Created by Maksym Horobets on 17.06.2025.
////
//
//import Foundation
//import FamilyControls
//import SwiftData
//
//extension BlockItem {
//    enum CodingKeys: CodingKey {
//        case id, emoji, name, schedules, blockedContent
//    }
//}
//
//extension BlockItem: Codable {
//    func encode(to encoder: any Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(emoji, forKey: .emoji)
//        try container.encode(name, forKey: .name)
//        try container.encode(blockedContent, forKey: .blockedContent)
//        try container.encode(schedules, forKey: .schedules)
//    }
//    convenience init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        let emoji = try container.decode(String.self, forKey: .emoji)
//        let name = try container.decode(String.self, forKey: .name)
//        let blockedContent = try container.decode(FamilyActivitySelection.self, forKey: .blockedContent)
//        let schedules = try container.decode([Schedule].self, forKey: .schedules)
//        
//        self.init(
//            name: name,
//            emoji: emoji,
//            blockedContent: blockedContent,
//            schedules: schedules
//        )
//    }
//}
