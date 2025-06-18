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
    private var modelContainer: ModelContainer
    let modelActor: BlockItemStore
    
    init(state: State = State()) {
        self.state = state
        let container = try! ModelContainer(
            for: BlockItem.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        self.modelContainer = container
        self.modelActor = BlockItemStore()
    }
    
    func insertANewItemIntoDatabase() async {
//        Task.detached(priority: .background) { [weak self] in
//            guard let self else { return }
            
            for _ in 0..<100 {
                let item = BlockItem(name: "Block", icon: "😜", blockedContent: FamilyActivitySelection())
                try? await modelActor.insert(item)
            }
//        }
        await MainActor.run {
            state.items = try! modelActor.fetchAll()
        }
    }
}
