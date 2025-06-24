//
//  BlockItemCodable.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import Foundation
import FamilyControls

extension BlockItem {
    enum CodingKeys: CodingKey {
        case id, name, emoji, schedules, blockedContent, isEnabled
    }
}

extension BlockItem: Codable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(emoji, forKey: .emoji)
        try container.encode(schedules, forKey: .schedules)
        try container.encode(blockedContent, forKey: .blockedContent)
        try container.encode(isEnabled, forKey: .isEnabled)
    }
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(UUID.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let emoji = try container.decode(String.self, forKey: .emoji)
        let schedules = try container.decode([Schedule].self, forKey: .schedules)
        let blockedContent = try container.decode(FamilyActivitySelection.self, forKey: .blockedContent)
        let isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        
        self.init(
            id: id,
            name: name,
            emoji: emoji,
            schedules: schedules,
            blockedContent: blockedContent,
            isEnabled: isEnabled
        )
    }
}
