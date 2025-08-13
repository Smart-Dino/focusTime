//
//  AppFlowCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import SwiftUI
import SwiftData
import Foundation

// MARK: - FullScreenCovers
enum AppFullScreenCover: Identifiable, Equatable {
    case freePlanPaywall(viewModel: FreePlanUpgradeViewModel)
    case onboardingPaywall(viewModel: OnboardingPaywallViewModel)
    case planSelectionPaywall(viewModel: PlanSelectionPaywallViewModel)
    
    var id: String {
        switch self {
        case .freePlanPaywall:
            String(describing: FreePlanUpgradeView.self)
        case .onboardingPaywall:
            String(describing: OnboardingPaywallView.self)
        case .planSelectionPaywall:
            String(describing: PlanSelectionPaywallView.self)
        }
    }
    
    static func == (lhs: AppFullScreenCover, rhs: AppFullScreenCover) -> Bool {
        switch (lhs, rhs) {
        case (.freePlanPaywall, .freePlanPaywall): true
        case (.onboardingPaywall, .onboardingPaywall): true
        case (.planSelectionPaywall, .planSelectionPaywall): true
        default: false
        }
    }
}

// MARK: - Implementation
@MainActor
@Observable
final class AppFlowCoordinatorViewModel {
    struct State {
        // MARK: - Screens
        enum AppScreen: Equatable, Hashable {
            case onboarding(viewModel: OnboardingFlowCoordinatorViewModel)
            case main(viewModel: MainFlowCoordinatorViewModel)
            case splash(viewModel: SplashScreenViewModel)
            case none
            
            static func == (lhs: AppScreen, rhs: AppScreen) -> Bool {
                switch (lhs, rhs) {
                case (.onboarding, .onboarding): true
                case (.main, .main):             true
                case (.splash, .splash):         true
                case (.none, .none):             true
                default:                         false
                }
            }
            
            func hash(into hasher: inout Hasher) {
                switch self {
                case .onboarding: hasher.combine(0)
                case .main: hasher.combine(1)
                case .splash: hasher.combine(2)
                case .none: hasher.combine(3)
                }
            }
        }
        
        var currentFlow: AppScreen
        var screenCover: AppFullScreenCover?
        var error: Error?
        
        init(currentFlow: AppScreen) {
            self.currentFlow = currentFlow
        }
    }
    
    private(set) var state: State
    private let shieldManager: ShieldManager
    private let defaultsManager: DefaultsManager
    private let persistenceStoreFactory: PersistenceStoreFactory
    private let paymentManagerFactory: PaymentManagerFactory
    
    // Async.
    private var deviceActivityRegistrar: DeviceActivityRegistrar?
    private var blockItemPersistenceManager: BlockItemPersistenceManager?
    private var paymentManager: PaymentManager?
    private var superPaywallVM: SuperPaywallViewModel?
    
    init(
        shieldManager: ShieldManager = LiveShieldManager(),
        defaultsManager: LiveDefaultsManager = LiveDefaultsManager(),
        paymentManagerFactory: PaymentManagerFactory = LivePaymentManagerFactory(),
        persistenceStoreFactory: PersistenceStoreFactory = LivePersistenceStoreFactory()
    ) {
        self.state = State(currentFlow: .none)
        self.shieldManager = shieldManager
        self.defaultsManager = defaultsManager
        self.paymentManagerFactory = paymentManagerFactory
        self.persistenceStoreFactory = persistenceStoreFactory
        
        showSplashScreen()
        Task {
            await setupAsyncDependencies()
            try? await Task.sleep(for: .seconds(SharedAppValues.splashScreenDuration))
            setupInitialAppState()
        }
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func setStateFlow(to screen: State.AppScreen?) {
        guard let screen else { return }
        withAnimation {
            state.currentFlow = screen
        }
    }
    
    func setScreenCover(to cover: AppFullScreenCover?) {
        if state.screenCover != cover {
            state.screenCover = cover
        }
    }
    
    func showSplashScreen() {
        state.currentFlow = .splash(viewModel: makeSplashScreenViewModel())
    }
    
    func showFreePlanCoverIfNeeded() async {
        guard let paymentManager else { return }
        
        guard await !paymentManager.isPro && state.screenCover == nil else {
            return
        }
        
        let viewModel = makeFreePlanUpgradeViewModel(
            requestedProductID: StoreKitProductIdentifiers.trialableWeekly.id
        )
        
        if let viewModel {
            setScreenCover(to: .freePlanPaywall(viewModel: viewModel))
        }
    }
    
    private func setupAsyncDependencies() async {
        // Async init dependencies.
        async let paymentManager = paymentManagerFactory.makePaymentManager()
        async let blockItemPersistenceManager = LiveBlockItemPersistenceManager(
            blockItemStore: persistenceStoreFactory.makeBlockItemStore(),
            deviceActivityCenterManager: LiveDeviceActivityCenterManager()
        )
        // Await init.
        self.paymentManager = await paymentManager
        self.superPaywallVM = await SuperPaywallViewModel(paymentManager: paymentManager)
        self.blockItemPersistenceManager = await blockItemPersistenceManager
        self.deviceActivityRegistrar = LiveDeviceActivityRegistrar(
            blockItemPersistenceManager: await blockItemPersistenceManager,
            shieldManager: shieldManager
        )
    }
    
    private func setupInitialAppState() {
        let isOnboardingFinished: Bool = defaultsManager.getValue(for: .isOnboardingFinished) ?? false
        
        if !isOnboardingFinished {
            setStateFlow(to: .onboarding(viewModel: makeOnboardingFlowCoordinatorViewModel()))
            return
        }
        
        if let viewModel = makeMainFlowCoordinatorViewModel() {
            setStateFlow(to: .main(viewModel: viewModel))
        }
    }
    
    // MARK: - Factory methods
    func makeSplashScreenViewModel() -> SplashScreenViewModel {
        SplashScreenViewModel()
    }
    
    private func makeOnboardingFlowCoordinatorViewModel() -> OnboardingFlowCoordinatorViewModel {
        OnboardingFlowCoordinatorViewModel(appFlowDelegate: self)
    }
    
    private func makeMainFlowCoordinatorViewModel() -> MainFlowCoordinatorViewModel? {
        guard let blockItemPersistenceManager, let deviceActivityRegistrar else { return nil }
        
        return MainFlowCoordinatorViewModel(
            deviceActivityRegistrar: deviceActivityRegistrar,
            blockItemPersistenceManager: blockItemPersistenceManager,
            appFlowDelegate: self,
        )
    }
    
    // Paywalls
    private func makeFreePlanUpgradeViewModel(requestedProductID: String) -> FreePlanUpgradeViewModel? {
        guard let superPaywallVM else { return nil }
        
        return FreePlanUpgradeViewModel(
            state: .init(requestedProductID: requestedProductID),
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
    }
    
    private func makeOnboardingPaywallViewModel(requestedProductID: String) -> OnboardingPaywallViewModel? {
        guard let superPaywallVM else { return nil }
        
        return OnboardingPaywallViewModel(
            state: .init(requestedProductID: requestedProductID),
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
    }
    
    private func makePlanSelectionPaywallViewModel() -> PlanSelectionPaywallViewModel? {
        guard let superPaywallVM else { return nil }
        
        return PlanSelectionPaywallViewModel(
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
    }
}

// MARK: - MainFlowNavigationDelegate
extension AppFlowCoordinatorViewModel: MainFlowDelegate {
    // MARK: Paywall
    func didRequestPaywallPlanSelection() {
        if let viewModel = makePlanSelectionPaywallViewModel() {
            setScreenCover(to: .planSelectionPaywall(viewModel: viewModel))
        }
    }
    
    func didRequestPaywallFreePlan() {
        if let viewModel = makeFreePlanUpgradeViewModel(
            requestedProductID: StoreKitProductIdentifiers.trialableWeekly.id
        ) {
            setScreenCover(
                to: .freePlanPaywall(
                    viewModel: viewModel
                )
            )
        }
    }
    
    // MARK: Onboarding
    func didRequestOnboarding() {
        setStateFlow(to: .onboarding(viewModel: makeOnboardingFlowCoordinatorViewModel()))
    }
    
    // MARK: Main Flow
    func didRequestMainFlow() {
        if let viewModel = makeMainFlowCoordinatorViewModel() {
            setStateFlow(to: .main(viewModel: viewModel))
        }
    }
}

// MARK: - OnboardingFlowNavigationDelegate
extension AppFlowCoordinatorViewModel: OnboardingFlowNavigationDelegate {
    func didFinishOnboarding() {
        defaultsManager.setValue(for: .isOnboardingFinished, to: true)
        if let mainVM = makeMainFlowCoordinatorViewModel() {
            setStateFlow(to: .main(viewModel: mainVM))
            if let onboardingPaywallVM = makeOnboardingPaywallViewModel(requestedProductID: StoreKitProductIdentifiers.trialableWeekly.id) {
                setScreenCover(
                    to: .onboardingPaywall(
                        viewModel: onboardingPaywallVM
                    )
                )
            }
        }
    }
}

// MARK: - PaywallNavigationDelegate
extension AppFlowCoordinatorViewModel: PaywallNavigationDelegate {
    func paywallDidRequestTermsOfService() {
#warning("No implementation")
        print("ToS requested")
    }
    
    func paywallDidRequestPrivacyPolicy() {
#warning("No implementation")
        print("Privacy requested")
    }
    
    func paywallDidRequestPlanSelection() {
        if let viewModel = makePlanSelectionPaywallViewModel() {
            setScreenCover(to: .planSelectionPaywall(viewModel: viewModel))
        }
    }
    
    func paywallDidRequestDismissal() {
        setScreenCover(to: nil)
    }
}
