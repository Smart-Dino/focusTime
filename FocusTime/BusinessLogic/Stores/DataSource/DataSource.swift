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
actor GlobalSourceActor {
    static let shared = GlobalSourceActor()
}

@MainActor
protocol DataSource {
    associatedtype Model: SwiftDataItem
    associatedtype ProtectedModel: Sendable
    #warning("Protected model for sendable representation")
    
    @GlobalSourceActor func insert(_ item: Model) async throws
    func delete(_ item: Model) throws
    func fetch() throws -> [Model]
    func fetch(descriptor: FetchDescriptor<Model>) throws -> [Model]
    
    func updateFields(of item: inout Model, using updates: (Model) -> Void) throws
    func eraseAllData() throws
}

@MainActor
protocol MyDataSource: DataSource where Model == BlockItem, ProtectedModel == String {
    
}
