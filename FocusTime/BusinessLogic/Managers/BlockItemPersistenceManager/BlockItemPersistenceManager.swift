//
//  BlockItemPersistenceManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 08.08.2025.
//

import SwiftData
import Foundation

protocol BlockItemPersistenceManager: Actor {
    func insert(_ item: ProtectedBlockItem) async throws
    func insert(_ item: inout ProtectedBlockItem) async throws
    
    func editBlockItem(blockItem: ProtectedBlockItem) async throws
    
    func fetch(by uuid: UUID) async throws -> ProtectedBlockItem?
    func fetch(by persistenceIdentifier: PersistentIdentifier) async throws -> ProtectedBlockItem
    func fetch(includeTemporary: Bool) async throws -> [ProtectedBlockItem]
    func fetchPaginated(page: Int, amountPerPage: Int, includeTemporary: Bool) async throws -> [ProtectedBlockItem]
    
    func eraseAllData() async throws
    
    func contextChangesStream() -> AsyncStream<Bool>
}
