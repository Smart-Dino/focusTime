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
    case customByUnit(value: Int, unit: Unit)
    case customSeconds(seconds: Int)
    
    // Constants for time calculations
    private static let secondsPerDay = 24 * 60 * 60 // 86,400
    private static let averageDaysPerMonth = 30.44 // More accurate average
    private static let averageDaysPerYear = 365.25 // Accounts for leap years
    
    /// Get the value in seconds using simple multiplication.
    var durationInSeconds: Int {
        switch self {
        case .weekly:
            return 7 * Self.secondsPerDay
        case .monthly:
            return Int(Self.averageDaysPerMonth * Double(Self.secondsPerDay))
        case .yearly:
            return Int(Self.averageDaysPerYear * Double(Self.secondsPerDay))
        case .customByUnit(value: let value, unit: let unit):
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
    
    // This method cannot be an extension on DateComponents,
    // since it relies on static properties of PeriodConverter
    /// Convert seconds back to approximate time components for display purposes.
    /// - Parameter seconds: The total duration in seconds
    /// - Returns: DateComponents with years, months, and days set
    static func approximateComponents(seconds: Int) -> DateComponents {
        let totalDays = Double(seconds) / Double(secondsPerDay)
        
        let years = Int(totalDays / averageDaysPerYear)
        let remainingDaysAfterYears = totalDays - (Double(years) * averageDaysPerYear)
        
        let months = Int(remainingDaysAfterYears / averageDaysPerMonth)
        let remainingDays = Int(remainingDaysAfterYears - (Double(months) * averageDaysPerMonth))
        
        var components = DateComponents()
        components.year = years
        components.month = months
        components.day = remainingDays
        
        return components
    }
}
