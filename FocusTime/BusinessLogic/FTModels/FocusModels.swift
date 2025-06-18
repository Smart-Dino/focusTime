//
//  FocusModels.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import Foundation

// MARK: - Placeholder models

/// Represents a single preset in the grid
struct FocusPreset: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iconName: String 
}




