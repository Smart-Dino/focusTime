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
    
    private(set) var state: State
    
    private let defaultsManager: DefaultsManager
    private let paymentManagerFactory: PaymentManagerFactory
    
    private var paymentManager: PaymentManager?
    private var modelContainer: ModelContainer?
    
    // MARK: - Init
    init(
        defaultsManager: DefaultsManager = LiveDefaultsManager(),
        paymentManagerFactory: PaymentManagerFactory = LivePaymentManagerFactory()
    ) {
        self.defaultsManager = defaultsManager
        self.paymentManagerFactory = paymentManagerFactory
        self.state = State(currentFlow: .splash(viewModel: SplashScreenViewModel()))
        
        Task { await startLaunchSequence() }
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible { state.error = nil }
    }
    
    // MARK: - Launch Sequence
    private func startLaunchSequence() async {
        async let splashDelay: Void = delayIfNeeded()
        async let dependencies: Void = setupDependencies()
        _ = await (splashDelay, dependencies)
        
        if let appFlowVM = makeAppFlowCoordinatorViewModel() {
            withAnimation { state.currentFlow = .appFlow(viewModel: appFlowVM) }
        }
    }
    
    // MARK: - Helpers
    private func delayIfNeeded() async {
        guard defaultsManager.getValue(for: .isOnboardingFinished) != true else { return }
        try? await Task.sleep(for: .seconds(SharedAppValues.splashScreenDuration))
    }
    
    private func setupDependencies() async {
        do {
            try setupModelContainer()
            try await setupPaymentManager()
        } catch {
            state.error = error
        }
    }
    
    private func setupModelContainer() throws {
        let schema = Schema([BlockItem.self])
        let config = ModelConfiguration(groupContainer: .identifier(SharedAppValues.appGroupIdentifier))
        modelContainer = try ModelContainer(for: schema, configurations: config)
    }
    
    private func setupPaymentManager() async throws {
        guard paymentManager == nil else { return }
        paymentManager = await StoreKitPaymentManager()
    }
    
    private func makeAppFlowCoordinatorViewModel() -> AppFlowCoordinatorViewModel? {
        guard let modelContainer, let paymentManager else { return nil }
        return AppFlowCoordinatorViewModel(
            defaultsManager: defaultsManager,
            modelContainer: modelContainer,
            paymentManager: paymentManager
        )
    }
}
