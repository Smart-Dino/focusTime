//
//  DefinedPeriod.swift
//  FocusTime
//
//  Created by Maksym Horobets on 23.05.2025.
//

import Foundation

/// Stores defined periods that can be easily and reliably converted to seconds and reused across the app.
enum PeriodConverter: Sendable {
    enum Unit: Sendable {
        case day, week, month, year
    }
    
    case weekly
    case monthly
    case yearly
    case customByUnit(value: Int?, unit: Unit?)
    case customSeconds(seconds: Int)
    
    // Constants for time calculations
    private static let secondsPerDay = 24 * 60 * 60 // 86,400
    private static let averageDaysPerMonth = 30.44 // More accurate average
    private static let averageDaysPerYear = 365.25 // Accounts for leap years
    
    /// Get the value in seconds using simple multiplication.
    var durationInSeconds: Int? {
        switch self {
        case .weekly:
            return 7 * Self.secondsPerDay
        case .monthly:
            return Int(Self.averageDaysPerMonth * Double(Self.secondsPerDay))
        case .yearly:
            return Int(Self.averageDaysPerYear * Double(Self.secondsPerDay))
        case .customByUnit(value: let value, unit: let unit):
            guard let value, let unit else { return nil }
            switch unit {
            case .day:
                return value * Self.secondsPerDay
            case .week:
                return value * 7 * Self.secondsPerDay
            case .month:
                return Int(Double(value) * Self.averageDaysPerMonth * Double(Self.secondsPerDay))
            case .year:
                return Int(Double(value) * Self.averageDaysPerYear * Double(Self.secondsPerDay))
            }
        case .customSeconds(seconds: let seconds):
            return seconds
        }
    }
    
    /// Returns a concise string for the largest significant time unit, e.g., "2 years", "1 month", or "0 seconds".
    ///
    /// - Prioritizes from years down to seconds.
    /// - If all components are nil or zero, defaults to "0 seconds".
    /// - For positive 1, the unit is singular (e.g., "1 year"); otherwise, it's plural (e.g., "0 years", "-1 years", "2 years").
    static func localizedConciseTimeString(
        from seconds: Int,
        allowedUnits: NSCalendar.Unit = [.year, .month, .weekOfMonth, .day],
        unitsStyle: DateComponentsFormatter.UnitsStyle = .full,
        maximumUnitsCount: Int = 1
    ) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = unitsStyle
        formatter.allowedUnits = allowedUnits
        formatter.maximumUnitCount = maximumUnitsCount // Only the largest non-zero unit
        formatter.zeroFormattingBehavior = .dropAll
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.calendar = .current

        let timeInterval = TimeInterval(seconds)
        return formatter.string(from: timeInterval) ?? String(localized: "common_zero_seconds_fallback",
                                                              table: "PaywallLocalizable",
                                                              comment: "Fallback for zero duration")
    }

}
