//
//  DurationComponentsTests.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 24.07.2025.
//

import Testing
import Foundation
@testable import FocusTime

@Suite("Tests for the DurationComponents")
struct DurationComponentsTests {
    
    @Test("dateComponents returns expected hour and minute")
    func testDateComponents() {
        let durationComponents = DurationComponents(hour: 5, minute: 45)
        let dateComponents = durationComponents.dateComponents
        #expect(dateComponents.hour == 5)
        #expect(dateComponents.minute == 45)
    }
    
    @Test("Initializer from hour/minute matches from duration")
    func testInitFromDuration() {
        let a = DurationComponents(hour: 2, minute: 30)
        let b = DurationComponents(duration: 2 * 3600 + 30 * 60)
        #expect(a == b)
    }
    
    @Test("durationDescription returns correct format",
          arguments: [
            (1, 30),
            (12, 0),
            (0, 59),
            (0, 0),
            (23, 59),
            (50, 00),
            (33, 00)
          ]
    )
    func testDurationDescription(hour: Int, minute: Int) {
        let expectedSeconds = hour * 3600 + minute * 60
        let durationComponents = DurationComponents(hour: hour, minute: minute)
        #expect(
            durationComponents.rawValue == expectedSeconds,
            "durationInSeconds did not match: got \(durationComponents.rawValue), expected: \(expectedSeconds)"
        )
    }
}
