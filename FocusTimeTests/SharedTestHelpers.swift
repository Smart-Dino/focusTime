//
//  SharedHelpers.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 04.07.2025.
//

import SwiftData
import Foundation
@testable import FocusTime

enum SharedTestHelpers {
    static func generateTestModelContainer() -> ModelContainer {
        let schema = Schema([BlockItem.self, Schedule.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true, groupContainer: .identifier(AppValues.appGroupIdentifier))
        let container = try! ModelContainer(for: schema, configurations: config)
        return container
    }
}
