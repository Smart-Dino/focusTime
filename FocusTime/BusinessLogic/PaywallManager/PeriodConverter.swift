//
//  DefinedPeriod.swift
//  FocusTime
//
//  Created by Maksym Horobets on 23.05.2025.
//

import Foundation

/// Stores deined periods that can be easily and reliably converted to seconds and reused acrossed the app.
enum PeriodConverter: Sendable {
    case weekly
    case monthly
    case yearly
    case everyThreeDays
    case everyTwoWeeks
    case everyTwoMonths
    case everyThreeMonths
    case everySixMonths
    
    private static let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        // Use UTC for all calendar calculations for consistency.
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        return cal
    }()
    
    // Durations for calendar components like "month" or "year" will be calculated
    // relative to this fixed point, ensuring consistent second counts
    private static let epochStartDate: Date = Date(timeIntervalSince1970: 0)
    
    /// Calculates the duration in seconds by adding calendar components to a predefined start date (epochStartDate).
    /// - Parameters:
    ///   - value: The number of units to add to the start date.
    ///   - component: The calendar component to which the value should be added (e.g., `.day`, `.month`, `.year`).
    /// - Returns: The calculated duration in seconds between the epochStartDate and the resulting future date.
    private static func durationInSeconds(
        byAdding value: Int,
        component: Calendar.Component
    ) -> Int {
        guard let futureDate = calendar.date(byAdding: component,
                                             value: value,
                                             to: epochStartDate) else {
            // This should ideally not happen with valid calendar, component, and epochStartDate.
            fatalError("Could not calculate future date for duration. Component: \(component), Value: \(value) from epoch.")
        }
        // The duration is the time interval (in seconds) between the epochStartDate and the calculated futureDate.
        return Int(futureDate.timeIntervalSince(epochStartDate))
    }
    
    static func components(
        fromSubscriptionSeconds totalSeconds: Int,
        components requestedComponents: Set<Calendar.Component> = [.year, .month, .day]
    ) -> DateComponents {
        let targetEndDate = Date(timeIntervalSince1970: TimeInterval(totalSeconds))
        // Calculate the difference between the epoch and the target end date
        // in terms of the requested components.
        let components = calendar.dateComponents(
            requestedComponents,
            from: epochStartDate,
            to: targetEndDate
        )
        
        return components
    }
    
    /// Get the value in seconds.
    var durationInSeconds: Int {
        switch self {
        case .weekly:
            Self.durationInSeconds(byAdding: 7, component: .day)
        case .monthly:
            Self.durationInSeconds(byAdding: 1, component: .month)
        case .yearly:
            Self.durationInSeconds(byAdding: 1, component: .year)
        case .everyThreeDays:
            Self.durationInSeconds(byAdding: 3, component: .day)
        case .everyTwoWeeks:
            Self.durationInSeconds(byAdding: 14, component: .day)
        case .everyTwoMonths:
            Self.durationInSeconds(byAdding: 2, component: .month)
        case .everyThreeMonths:
            Self.durationInSeconds(byAdding: 3, component: .month)
        case .everySixMonths:
            Self.durationInSeconds(byAdding: 6, component: .month)
        }
    }
}
