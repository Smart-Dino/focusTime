//
//  DataSource.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftData
import Foundation


protocol ProtectedModel: Sendable, Identifiable {
    associatedtype Model: PersistentModel
    
    var persistentModelID: PersistentIdentifier? { get }
    
    init(from item: Model)
}

extension ProtectedModel {
    var id: Int { persistentModelID?.id.hashValue ?? UUID().hashValue }
}

protocol DataSource: ModelActor where SendableModel.Model == Model {
    associatedtype Model: PersistentModel
    associatedtype SendableModel: ProtectedModel

    func insert(_ item: SendableModel) throws
    func insertBatch(_ items: [SendableModel]) throws
    
    func delete(id: PersistentIdentifier) throws
    
    func fetch() throws -> [SendableModel]
    func fetch(id: PersistentIdentifier) throws -> SendableModel?
    func fetch(descriptor: FetchDescriptor<Model>) throws -> [SendableModel]
    
    func updateFields(id: PersistentIdentifier, using updates: (Model) -> Void) throws
    func eraseAllData() throws
}

