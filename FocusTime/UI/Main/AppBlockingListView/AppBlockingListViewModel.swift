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
        var items = [BlockItem]()
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
            for _ in 0..<100 {
                let item = ProtectedBlockItem(emoji: "😜", name: "Block", blockedContent: FamilyActivitySelection())
                try? await blockItemStore.insert(item)
            }
            try? await MainActor.run {
                self.state.items = try self.modelContainer.mainContext.fetch(.init())
            }
        }
    }
}

