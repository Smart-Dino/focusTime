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

enum DataSourceError: LocalizedError {
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            "The requested model was not found in the modelContext."
        }
    }
}

@MainActor
protocol DataSource {
    associatedtype Model: SwiftDataItem
    
    func insert(_ item: Model) throws
    func delete(_ item: Model) throws
    func fetchAll() throws -> [Model]
    
    func updateFields(of item: inout Model, using updates: (Model) -> Void) throws
}
