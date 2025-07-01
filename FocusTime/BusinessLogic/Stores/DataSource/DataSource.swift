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
protocol SwiftDataItem: Identifiable, PersistentModel { }

protocol DataSource: ModelActor {
    associatedtype Model: SwiftDataItem
    associatedtype ProtectedModel: Sendable

    func insert(_ item: ProtectedModel) throws
    func delete(id: PersistentIdentifier) throws
    func fetch() throws -> [Model]
    func fetch(id: PersistentIdentifier) throws -> Model?
    func fetch(descriptor: FetchDescriptor<Model>) throws -> [Model]
    func updateFields(id: PersistentIdentifier, using updates: (Model) -> Void) throws
    func eraseAllData() throws
}
