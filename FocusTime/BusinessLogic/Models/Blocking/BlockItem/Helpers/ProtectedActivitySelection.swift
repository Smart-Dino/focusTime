//
//  ProtectedActivitySelection.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.07.2025.
//

import Foundation
import FamilyControls

struct ProtectedActivitySelection: Codable, @unchecked Sendable {
    let selection: FamilyActivitySelection
    
    init(_ activitySelection: FamilyActivitySelection) {
        self.selection = activitySelection
    }
}
