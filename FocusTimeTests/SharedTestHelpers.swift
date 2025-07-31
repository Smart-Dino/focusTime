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
        let schema = Schema([BlockItem.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true, groupContainer: .identifier(AppValues.appGroupIdentifier))
        do {
            let container = try ModelContainer(for: schema, configurations: config)
            return container
        } catch {
            fatalError("Failed to create test ModelContainer: \(error)")
        }
    }
}
