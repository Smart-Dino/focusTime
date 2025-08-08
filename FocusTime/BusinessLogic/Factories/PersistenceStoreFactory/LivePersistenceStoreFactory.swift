//
//  LivePersistenceStoreFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 08.08.2025.
//

import SwiftData

actor LivePersistenceStoreFactory: PersistenceStoreFactory {
    private let modelContainer: ModelContainer
    
    init() {
        do {
            let schema = Schema([BlockItem.self])
            let config = ModelConfiguration(groupContainer: .identifier(SharedAppValues.appGroupIdentifier))
            let container = try ModelContainer(for: schema, configurations: config)
            
            self.modelContainer = container
        } catch {
            fatalError("Could not setup database.")
        }
    }
    func makeBlockItemStore() -> BlockItemStore {
        BlockItemStore(modelContainer: modelContainer)
    }
}
