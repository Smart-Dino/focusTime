//
//  LaunchFlowCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.08.2025.
//

import SwiftData
import Foundation

@MainActor
@Observable
final class LaunchFlowCoordinatorViewModel {
    struct State {
        var error: Error?
        var appFlowCoordinatorViewModel: AppFlowCoordinatorViewModel?
    }
    
    private(set) var state: State
    let modelContainer: ModelContainer
    let defaultsManager: DefaultsManager
    
    init() {
        let schema = Schema([BlockItem.self])
        let config = ModelConfiguration(groupContainer: .identifier(SharedAppValues.appGroupIdentifier))
        let container = try! ModelContainer(for: schema, configurations: config)
        
        self.state = State()
        self.modelContainer = container
        self.defaultsManager = LiveDefaultsManager()
        
        setupAppFlowViewModel()
    }
    
    func setupAppFlowViewModel() {
        Task {
            if state.appFlowCoordinatorViewModel == nil {
                let paymentManager = await StoreKitPaymentManager()
                
                self.state.appFlowCoordinatorViewModel = .init(
                    defaultsManager: defaultsManager,
                    modelContainer: modelContainer,
                    paymentManager: paymentManager
                )
            }
        }
    }
}
