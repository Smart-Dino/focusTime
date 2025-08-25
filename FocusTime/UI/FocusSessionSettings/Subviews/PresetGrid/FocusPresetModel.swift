//
//  FocusPresetModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 21.07.25.
//

import Foundation

// MARK: - FocusPreset Enum
enum FocusPreset: String, CaseIterable, Identifiable {
    case morningRoutine
    case socialDetox
    case workSprint
    case zeroDistraction
    case study
    case creative
    case mindfulness
    case reading
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .morningRoutine: return String(
            localized: "Morning\nRoutine",
            table: "SessionLocalizable",
            comment: "Focus preset: Morning Routine"
        )
        case .socialDetox: return String(
            localized: "Social\nDetox",
            table: "SessionLocalizable",
            comment: "Focus preset: Social Detox"
        )
        case .workSprint: return String(
            localized: "Work\nSprint",
            table: "SessionLocalizable",
            comment: "Focus preset: Work Sprint"
        )
        case .zeroDistraction: return String(
            localized: "Zero\nDistraction",
            table: "SessionLocalizable",
            comment: "Focus preset: Zero Distraction"
        )
        case .study: return String(
            localized: "Study",
            table: "SessionLocalizable",
            comment: "Focus preset: Study"
        )
        case .creative: return String(
            localized: "Creative",
            table: "SessionLocalizable",
            comment: "Focus preset: Creative"
        )
        case .mindfulness: return String(
            localized: "Mindfulness",
            table: "SessionLocalizable",
            comment: "Focus preset: Mindfulness"
        )
        case .reading: return String(
            localized: "Reading",
            table: "SessionLocalizable",
            comment: "Focus preset: Reading"
        )
        }
    }
    
    var emoji: String {
        switch self {
        case .morningRoutine: return "☀️"
        case .socialDetox: return "📴"
        case .workSprint: return "⏱️"
        case .zeroDistraction: return "🚫"
        case .study: return "📚"
        case .creative: return "🎨"
        case .mindfulness: return "🧠"
        case .reading: return "📖"
        }
    }
    
    static func getPreset(for name: String, emoji: String) -> FocusPreset? {
        allCases.first { preset in
            preset.name == name && preset.emoji == emoji
        }
    }
    
}
