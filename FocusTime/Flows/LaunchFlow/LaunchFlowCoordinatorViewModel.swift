//
//  LaunchFlowCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.08.2025.
//

import SwiftUI
import SwiftData

// MARK: - Screens
enum LaunchScreen: Equatable, Hashable {
    case appFlow(viewModel: AppFlowCoordinatorViewModel)
    case splash(viewModel: SplashScreenViewModel)
    
    static func == (lhs: LaunchScreen, rhs: LaunchScreen) -> Bool {
        switch (lhs, rhs) {
        case (.appFlow, .appFlow): true
        case (.splash, .splash):   true
        default:                   false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .appFlow: hasher.combine(0)
        case .splash: hasher.combine(1)
        }
    }
}

@MainActor
@Observable
final class LaunchFlowCoordinatorViewModel {
    struct State {
        var error: Error?
        var currentFlow: LaunchScreen
        var appFlowCoordinatorViewModel: AppFlowCoordinatorViewModel?
    }
    
    private(set) var state: State!
    private let defaultsManager: DefaultsManager
    private var paymentManager: PaymentManager?
    private var modelContainer: ModelContainer?
    
    init() {
        self.defaultsManager = LiveDefaultsManager()
        self.state = State(currentFlow: .splash(viewModel: makeSplashScreenViewModel()))
        
        setupManagersAndSwitchToAppFlow()
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    private func setupManagersAndSwitchToAppFlow() {
        Task {
            setupModelContainer()
            await setupPaymentManager()
            
            try await Task.sleep(for: .seconds(SharedAppValues.splashScreenDuration))
            if let viewModel = makeAppFlowCoordinatorViewModel() {
                withAnimation {
                    self.state.currentFlow = .appFlow(viewModel: viewModel)
                }
            }
        }
    }
    
    // This is done separately for error handling.
    private func setupModelContainer() {
        do {
            let schema = Schema([BlockItem.self])
            let config = ModelConfiguration(groupContainer: .identifier(SharedAppValues.appGroupIdentifier))
            let container = try ModelContainer(for: schema, configurations: config)
            
            self.modelContainer = container
        } catch {
            state.error = error
        }
    }
    
    private func setupPaymentManager() async {
        guard paymentManager == nil else { return }
        
        paymentManager = await StoreKitPaymentManager()
    }
    
    
    func makeSplashScreenViewModel() -> SplashScreenViewModel {
        SplashScreenViewModel()
    }
    
    func makeAppFlowCoordinatorViewModel() -> AppFlowCoordinatorViewModel? {
        guard let modelContainer, let paymentManager else { return nil }
        
        return AppFlowCoordinatorViewModel(
            defaultsManager: defaultsManager,
            modelContainer: modelContainer,
            paymentManager: paymentManager
        )
    }
}
