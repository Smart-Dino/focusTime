//
//  ProtectedActivitySelection.swift
//  FocusTime
//
//  Created by Maksym Horobets on 15.07.2025.
//

import Foundation
import FamilyControls

struct ProtectedActivitySelection: Codable, Equatable, @unchecked Sendable {
    let selection: FamilyActivitySelection
    
    init(_ activitySelection: FamilyActivitySelection) {
        self.selection = activitySelection
    }
}

extension ProtectedActivitySelection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(selection.categoryTokens)
        hasher.combine(selection.applicationTokens)
        hasher.combine(selection.webDomainTokens)
    }
}
