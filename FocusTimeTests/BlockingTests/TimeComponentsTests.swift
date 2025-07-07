//
//  TimeComponentsTests.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 07.07.2025.
//

import Testing
import Foundation
@testable import FocusTime

@Suite("Tests for the TimeComponents")
struct TimeComponentsTests {
    
    @Test("Convert TimeComponents to Foundation.DateComponents",
          arguments: [
            (17, 0),
            (23, 59),
            (0, 0),
            (11, 11),
            (1, 1)
          ]
    )
    func dateComponentsConversion(
        hour: Int,
        minute: Int,
    ) async throws {
        let timeComponents = try #require(TimeComponents(hour: hour, minute: minute))
        let components = timeComponents.dateComponents
        #expect(
            components.hour == hour,
            "Hour did not match. Got: \(String(describing: components.hour)), expected: \(hour)"
        )
        #expect(
            components.minute == minute,
            "Minute did not match. Got: \(String(describing: components.minute)), expected: \(minute)"
        )
    }
    
    @Test(
        "Initializer sets timeSince1970 to correct seconds",
        arguments: [
            (0, 0),
            (0, 1),
            (1, 0),
            (12, 34),
            (23, 59)
        ]
    )
    func testInitSetsSeconds(hour: Int, minute: Int) async throws {
        let expectedSeconds = hour * 3600 + minute * 60
        let timeComponents = try #require(TimeComponents(hour: hour, minute: minute))
                
        let reconstructed = TimeComponents(secondsSince1970: expectedSeconds)
        #expect(
            reconstructed == timeComponents,
            "TimeComponents(hour: \(hour), minute: \(minute)) should equal TimeComponents(secondsSince1970: \(expectedSeconds))"
        )
    }
    
    @Test(
        "Initializer from Date sets correct hour and minute",
        arguments: [
            (0, 0),
            (12, 0),
            (23, 59),
            (1, 1),
            (17, 45)
        ]
    )
    func testInitFromDate(hour: Int, minute: Int) async throws {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        
        let calendar = Calendar.current
        let date = try #require(calendar.date(from: components))
        
        let timeComponents = try #require(TimeComponents(from: date))
        #expect(
            timeComponents.dateComponents.hour == hour,
            "Expected hour to be \(hour), got \(String(describing: timeComponents.dateComponents.hour))"
        )
        #expect(
            timeComponents.dateComponents.minute == minute,
            "Expected minute to be \(minute), got \(String(describing: timeComponents.dateComponents.minute))"
        )
    }
    
}
