//
//  PersistenceStore.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftData
import Foundation

protocol PersistenceStore: ModelActor where SendableModel.Model == Model {
    associatedtype Model: PersistentModel
    associatedtype SendableModel: ProtectedModel
    
    func insert(_ item: SendableModel) throws  -> PersistentIdentifier
    func insertBatch(_ items: [SendableModel]) throws -> Set<PersistentIdentifier>
    
    func delete(id: PersistentIdentifier) throws
    
    func fetch() throws -> [SendableModel]
    func fetch(page: Int, amountPerPage: Int) throws -> [SendableModel]
    func fetch(id: PersistentIdentifier) throws -> SendableModel
    func fetch(descriptor: FetchDescriptor<Model>) throws -> [SendableModel]
    
    func updateFields(id: PersistentIdentifier, using updates: (Model) -> Void) throws
    func eraseAllData() throws
}
