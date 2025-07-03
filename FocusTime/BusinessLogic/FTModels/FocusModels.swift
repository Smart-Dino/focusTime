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

enum Weekday: String, CaseIterable, Identifiable, Codable, Comparable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday

    var id: String { self.rawValue }

    var shortName: String {
        switch self {
        case .sunday: return "Sun"
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        }
    }
    
    private var sortOrder: Int {
        switch self {
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        case .sunday: return 7
        }
    }

    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}



