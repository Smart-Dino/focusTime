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
    private let paymentManagerFactory: PaymentManagerFactory
    private var modelContainer: ModelContainer?
    
    init(
        state: State = State(),
        defaultsManager: DefaultsManager = LiveDefaultsManager(),
        paymentManagerFactory: PaymentManagerFactory = LivePaymentManagerFactory()
    ) {
        self.state = state
        self.defaultsManager = defaultsManager
        self.paymentManagerFactory = paymentManagerFactory
        
        setupModelContainer()
        setupAppFlowViewModel()
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
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
            guard state.error == nil else { return }
            
            // Make sure we have modelContainer and our ViewModel has not yet bee initialized.
            if let modelContainer, state.appFlowCoordinatorViewModel == nil {
                let paymentManager = await paymentManagerFactory.makePaymentManager()
                
                self.state.appFlowCoordinatorViewModel = .init(
                    defaultsManager: defaultsManager,
                    modelContainer: modelContainer,
                    paymentManager: paymentManager
                )
            }
        }
    }
}
