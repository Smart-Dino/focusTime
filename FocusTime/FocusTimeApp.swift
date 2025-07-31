//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI
import SwiftData

#warning("When creating a splash screen make sure to handle ModelContainer errors!")

@main
struct FocusTimeApp: App {
    let modelContainer: ModelContainer
    let defaultsManager: DefaultsManager
    
    var body: some Scene {
        WindowGroup {
            AppFlowCoordinatorView(
                viewModel: .init(defaultsManager: defaultsManager, modelContainer: modelContainer)
            )
        }
    }
    
    init() {
        let schema = Schema([BlockItem.self])
        let config = ModelConfiguration(groupContainer: .identifier(SharedAppValues.appGroupIdentifier))
        let container = try! ModelContainer(for: schema, configurations: config)
        
        self.modelContainer = container
        self.defaultsManager = LiveDefaultsManager()
    }
}
