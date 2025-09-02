//
//  String+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 25.08.2025.
//

import Foundation

extension String {
    func filterToFirstEmoji() -> String {
        String(self.filter({ $0.isEmoji }).prefix(1))
    }
    /// Returns a single-line version of the string,
    /// replacing line breaks with spaces and collapsing multiple spaces.
    func collapsedLines() -> String {
        self
            .replacingOccurrences(of: "\n", with: " ") // turn newlines into spaces
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression) // collapse multiple spaces
            .trimmingCharacters(in: .whitespacesAndNewlines) // clean up edges
    }
}
