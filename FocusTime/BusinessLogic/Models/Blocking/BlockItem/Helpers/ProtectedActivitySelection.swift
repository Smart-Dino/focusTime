//
//  ProtectedActivitySelection.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.07.2025.
//

import Foundation
import FamilyControls

struct ProtectedActivitySelection: Codable {
    private let data: Data
    
    nonisolated var nonisolatedSelection: FamilyActivitySelection {
        try! JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    }
    
    init(_ activitySelection: FamilyActivitySelection) {
        self.data = try! JSONEncoder().encode(activitySelection)
    }
}
