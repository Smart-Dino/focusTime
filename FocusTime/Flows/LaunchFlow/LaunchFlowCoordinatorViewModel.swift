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
    private let defaultsManager: DefaultsManager
    private var modelContainer: ModelContainer?
    
    init() {
        self.state = State()
        self.defaultsManager = LiveDefaultsManager()
        
        setupModelContainer()
        setupAppFlowViewModel()
    }
    
    func keepShowingError(showError: Bool) {
        if !showError {
            state.error = nil
        }
    }
    
    func setupModelContainer() {
        do {
            let schema = Schema([BlockItem.self])
            let config = ModelConfiguration(groupContainer: .identifier(SharedAppValues.appGroupIdentifier))
            let container = try ModelContainer(for: schema, configurations: config)
            
            self.modelContainer = container
        } catch {
            state.error = error
        }
    }
    
    func setupAppFlowViewModel() {
        Task {
            if let modelContainer, state.appFlowCoordinatorViewModel == nil {
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
