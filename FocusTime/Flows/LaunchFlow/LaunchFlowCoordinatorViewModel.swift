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
    private var blockItemPersistenceManager: BlockItemPersistenceManager?
    private var persistenceStoreFactory: PersistenceStoreFactory
    
    init(persistenceStoreFactory: PersistenceStoreFactory) {
        self.persistenceStoreFactory = persistenceStoreFactory
        self.defaultsManager = LiveDefaultsManager()
        self.state = State(currentFlow: .splash(viewModel: makeSplashScreenViewModel()))
        
        Task {
            await setupDependencies()
            await switchToAppFlow()
        }
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    private func setupDependencies() async {
        await setupBlockItemStore()
        await setupPaymentManager()
    }
    
    private func switchToAppFlow() async {
        try? await Task.sleep(for: .seconds(SharedAppValues.splashScreenDuration))
        if let viewModel = makeAppFlowCoordinatorViewModel() {
            withAnimation {
                self.state.currentFlow = .appFlow(viewModel: viewModel)
            }
        }
    }
    
    private func setupBlockItemStore() async {
        guard blockItemPersistenceManager == nil else { return }
        
        blockItemPersistenceManager = await LiveBlockItemPersistenceManager(
            blockItemStore: persistenceStoreFactory.makeBlockItemStore()
        )
    }
    
    private func setupPaymentManager() async {
        guard paymentManager == nil else { return }
        
        paymentManager = await StoreKitPaymentManager()
    }
    
    func makeSplashScreenViewModel() -> SplashScreenViewModel {
        SplashScreenViewModel()
    }
    
    func makeAppFlowCoordinatorViewModel() -> AppFlowCoordinatorViewModel? {
        guard let blockItemPersistenceManager, let paymentManager else { return nil }
        
        return AppFlowCoordinatorViewModel(
            defaultsManager: defaultsManager,
            blockItemPersistenceManager: blockItemPersistenceManager,
            paymentManager: paymentManager
        )
    }
}
