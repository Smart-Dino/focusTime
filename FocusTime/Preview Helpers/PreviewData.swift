//
//  PreviewData.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//

import SwiftData
import Foundation

enum PreviewData {
    static let memoryOnlyBlockItemStore: BlockItemStore = {
        do {
            let container = try ModelContainer(
                for: .init([BlockItem.self]),
                configurations: [
                    .init(isStoredInMemoryOnly: true)
                ]
            )
            
            let store = BlockItemStore(modelContainer: container)
            
            return store
        } catch {
            fatalError("Failed to create preview ModelContainer: \(error)")
        }
    }()
    
    static let mockBlockItemPersistenceManager = {
        return LiveBlockItemPersistenceManager(
            blockItemStore: PreviewData.memoryOnlyBlockItemStore,
            deviceActivityCenterManager: LiveDeviceActivityCenterManager()
        )
    }()
    
}
