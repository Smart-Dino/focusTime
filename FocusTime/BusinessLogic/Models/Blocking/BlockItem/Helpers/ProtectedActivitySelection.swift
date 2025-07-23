//
//  ProtectedActivitySelection.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.07.2025.
//

import Foundation
import FamilyControls

//struct ProtectedActivitySelection: Codable {
//    private let data: Data?
//    
//    nonisolated var nonisolatedSelection: FamilyActivitySelection {
//        guard let data,
//              let result = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
//        else { return FamilyActivitySelection() }
//        return result
//    }
//    
//    init(_ activitySelection: FamilyActivitySelection) {
//        self.data = try? JSONEncoder().encode(activitySelection)
//    }
//}

struct ProtectedActivitySelection: Codable, @unchecked Sendable {
    let selection: FamilyActivitySelection
    
    init(_ activitySelection: FamilyActivitySelection) {
        self.selection = activitySelection
    }
}
