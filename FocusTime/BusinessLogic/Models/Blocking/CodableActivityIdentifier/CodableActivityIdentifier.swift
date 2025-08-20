//
//  CodableActivityIdentifier.swift
//  FocusTime
//
//  Created by Maksym Horobets on 10.07.2025.
//

import Foundation
import DeviceActivity

struct CodableActivityIdentifier: Codable {
    enum BlockType: Codable {
        case regular
        case fallback
        case resumption
    }
    
    let blockItemID: UUID
    let blockType: BlockType
}

extension CodableActivityIdentifier {
    var jsonString: String? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    init?(from name: DeviceActivityName) {
        let decoder = JSONDecoder()
        
        guard let jsonData = name.rawValue.data(using: .utf8),
              let decodedActivity = try? decoder.decode(CodableActivityIdentifier.self, from: jsonData)
        else { return nil }
        
        self = decodedActivity
    }
}
