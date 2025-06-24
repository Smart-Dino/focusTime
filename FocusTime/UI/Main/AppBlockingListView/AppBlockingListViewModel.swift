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
    private let blockItemStore: BlockItemStore
    
    init(state: State = State(), blockItemStore: BlockItemStore = BlockItemStore()) {
        self.state = state
        self.blockItemStore = blockItemStore
    }
    
    func insertTestItemsIntoDatabase() async {
        for _ in 0..<100 {
            let item = BlockItem(name: "Block", emoji: "😜", blockedContent: FamilyActivitySelection())
            try? await blockItemStore.insert(item)
        }
        await MainActor.run {
            state.items = try! blockItemStore.fetchAll()
        }
    }
}
