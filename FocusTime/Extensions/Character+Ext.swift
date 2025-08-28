//
//  Character+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 25.08.2025.
//

import Foundation

extension Character {
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value > 0x238C || unicodeScalars.count > 1)
    }
}
