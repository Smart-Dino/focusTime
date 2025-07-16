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
        let timeComponents = TimeComponents(hour: hour, minute: minute)
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
        let timeComponents = TimeComponents(hour: hour, minute: minute)
                
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
    
    @Test("localizedTimeSince1970 returns expected seconds in local time",
          arguments: [
            (0, 0),
            (12, 34),
            (23, 59)
          ]
    )
    func testLocalizedTimeSince1970(hour: Int, minute: Int) async throws {
        let timeComponents = TimeComponents(hour: hour, minute: minute)
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = .gmt
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        
        let date = try #require(utcCalendar.date(from: components))
        let expectedSeconds = utcCalendar.component(.second, from: date)
        #expect(
            timeComponents.localizedTimeSince1970 == expectedSeconds,
            "Expected localizedTimeSince1970 to be \(expectedSeconds), got \(timeComponents.localizedTimeSince1970)"
        )
    }

    @Test("description produces a valid time string",
          arguments: [
            (8, 30),
            (0, 0),
            (23, 45)
          ]
    )
    func testDescription(hour: Int, minute: Int) async throws {
        let timeComponents = TimeComponents(hour: hour, minute: minute)
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        
        let date = try #require(Calendar.current.date(from: components))
        let expected = formatter.string(from: date)
        #expect(
            timeComponents.description == expected,
            "description did not match: got \(timeComponents.description), expected: \(expected)"
        )
    }

    @Test("durationDescription returns correct format",
          arguments: [
            (1, 30),
            (12, 0),
            (0, 59),
            (0, 0),
            (23, 59)
          ]
    )
    func testDurationDescription(hour: Int, minute: Int) async throws {
        let timeComponents = TimeComponents(hour: hour, minute: minute)
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        
        let expected = formatter.string(from: components) ?? "-"
        #expect(
            timeComponents.durationDescription == expected,
            "durationDescription did not match: got \(timeComponents.durationDescription), expected: \(expected)"
        )
    }

    @Test("localizedDate returns date with correct hour and minute",
          arguments: [
            (0, 0),
            (13, 45),
            (23, 59)
          ]
    )
    func testLocalizedDate(hour: Int, minute: Int) async throws {
        let timeComponents = TimeComponents(hour: hour, minute: minute)
        let date = timeComponents.localizedDate
        
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.hour, .minute], from: date)
        
        #expect(
            comps.hour == hour,
            "localizedDate hour mismatch: got \(String(describing: comps.hour)), expected: \(hour)"
        )
        #expect(
            comps.minute == minute,
            "localizedDate minute mismatch: got \(String(describing: comps.minute)), expected: \(minute)"
        )
    }
    
}
