//
//  MockPersistenceStoreFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 08.08.2025.
//

import SwiftData

actor MockPersistenceStoreFactory: PersistenceStoreFactory {
    private let modelContainer: ModelContainer
    
    init() {
        do {
            let schema = Schema([BlockItem.self])
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: schema, configurations: config)
            
            self.modelContainer = container
        } catch {
            fatalError("Could not setup database: \(error).")
        }
    }
    func makeBlockItemStore() -> BlockItemStore {
        BlockItemStore(modelContainer: modelContainer)
    }
}
