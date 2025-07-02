//
//  AppBlockingListViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import Foundation
import SwiftData
import FamilyControls

@MainActor
@Observable
final class AppBlockingListViewModel {
    struct State {
        var items = [ProtectedBlockItem]()
    }
    
    private(set) var state: State
    private let modelContainer: ModelContainer
    
    init(state: State = State(), modelContainer: ModelContainer) {
        self.state = state
        self.modelContainer = modelContainer
    }
    
    func insertTestItemsIntoDatabase() async {
        Task.detached(priority: .userInitiated) {
            let blockItemStore = BlockItemStore(modelContainer: self.modelContainer)
            let itemsToInsert = Array(
                repeating: ProtectedBlockItem(emoji: "😜", name: "Block", blockedContent: FamilyActivitySelection()),
                count: 100000
            )
            try? await blockItemStore.insertBatch(itemsToInsert)
            let insertedItems = try? await blockItemStore.fetch()
            await MainActor.run {
                self.state.items = insertedItems ?? []
            }
        }
    }
}
