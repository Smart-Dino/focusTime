//
//  DataSource.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftData
import Foundation

// Typealias would not work here because
// it will be treated as a redundant conformance to PersistentModel.
protocol SwiftDataItem: Codable, Identifiable, PersistentModel { }

// Serialize writes to the database on a custom, global actor.
// This is a custom-defined actor, much like MainActor is
// so this actor will never cross MainActor and run DB writes off the main thread.
@globalActor
actor GlobalStoreActor {
    static let shared = GlobalStoreActor()
}

@MainActor
protocol DataSource {
    associatedtype Model: SwiftDataItem
    
    @GlobalStoreActor func insert(_ item: Model) async throws
    func delete(_ item: Model) throws
    func fetchAll() throws -> [Model]
    
    func updateFields(of item: inout Model, using updates: (Model) -> Void) throws
}
