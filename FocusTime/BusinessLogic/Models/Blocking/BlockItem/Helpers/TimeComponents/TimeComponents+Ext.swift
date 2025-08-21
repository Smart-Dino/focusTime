//
//  TimeComponents+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 07.08.2025.
//

import Foundation

extension TimeComponents: Comparable {
    static func < (lhs: TimeComponents, rhs: TimeComponents) -> Bool {
        lhs.localizedSecondsSinceMidnight < rhs.localizedSecondsSinceMidnight
    }
}

extension TimeComponents {
    /// Initializes a `TimeComponents` instance from a string in "HH:mm" format.
    /// - Parameter string: Time string like "08:30" or "23:45".
    init(from string: String) throws {
        let parts = string.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else {
            throw Error.invalidTime
        }
        try self.init(hour: parts[0], minute: parts[1])
    }
}
