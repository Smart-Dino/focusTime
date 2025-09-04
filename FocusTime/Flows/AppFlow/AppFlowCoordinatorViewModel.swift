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
                case .main:       hasher.combine(1)
                case .splash:     hasher.combine(2)
                case .none:       hasher.combine(3)
                }
            }
        }
        
        var currentFlow: AppScreen
        var screenCover: AppFullScreenCover?
        
        init(currentFlow: AppScreen) {
            self.currentFlow = currentFlow
        }
    }
    
    private(set) var state: State
    
    private let shieldManager: ShieldManager
    private let defaultsManager: DefaultsManager
    private let paywallPresenter: PaywallPresenter
    private let persistenceStoreFactory: PersistenceStoreFactory
    private let paymentManagerFactory: PaymentManagerFactory
    
    // Async
    private var deviceActivityRegistrar: DeviceActivityRegistrar?
    private var blockItemPersistenceManager: BlockItemPersistenceManager?
    private var paymentManager: PaymentManager?
    private var superPaywallVM: SuperPaywallViewModel?
    
    private var analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()
    
    init(
        state: State = State(currentFlow: .splash(viewModel: SplashScreenViewModel())),
        paywallPresenter: PaywallPresenter = LivePaywallPresenter(),
        shieldManager: ShieldManager = LiveShieldManager(),
        defaultsManager: LiveDefaultsManager = LiveDefaultsManager(),
        paymentManagerFactory: PaymentManagerFactory = LivePaymentManagerFactory(),
        persistenceStoreFactory: PersistenceStoreFactory = LivePersistenceStoreFactory()
    ) {
        self.state = state
        self.shieldManager = shieldManager
        self.defaultsManager = defaultsManager
        self.paymentManagerFactory = paymentManagerFactory
        self.persistenceStoreFactory = persistenceStoreFactory
        self.paywallPresenter = paywallPresenter
        
        paywallPresenter.paywallCoordinator = self
        
        Task { await startLaunchSequence() }
    }
    
    func setStateFlow(to screen: State.AppScreen?) {
        guard let screen else { return }
        withAnimation {
            state.currentFlow = screen
        }
        
        /// - Analytics
        switch screen {
        case .onboarding:
            analyticsManager.logEvent(name: "app_flow_onboarding_started", parameters: nil)
        case .main:
            analyticsManager.logEvent(name: "app_flow_main_flow_started", parameters: nil)
        case .splash:
            analyticsManager.logEvent(name: "app_flow_splash_screen_shown", parameters: nil)
        case .none:
            break
        }
    }
    
    func setScreenCover(to cover: AppFullScreenCover?) {
        if state.screenCover != cover {
            state.screenCover = cover
            
            /// - Analytics
            if let cover = cover {
                switch cover {
                case .freePlanPaywall:
                    analyticsManager.logEvent(name: "paywall_free_plan_shown", parameters: nil)
                case .onboardingPaywall:
                    analyticsManager.logEvent(name: "paywall_onboarding_paywall_shown", parameters: nil)
                case .planSelectionPaywall:
                    analyticsManager.logEvent(name: "paywall_plan_selection_paywall_shown", parameters: nil)
                }
            } else {
                analyticsManager.logEvent(name: "paywall_dismissed", parameters: nil)
            }
        }
    }
    
    func showFreePlanCoverIfNeeded() async {
        guard let paymentManager else { return }
        
        guard !paymentManager.state.status.isPro && state.screenCover == nil else { return }
        
        if let viewModel = makeFreePlanUpgradeViewModel(
            requestedProductID: StoreKitProductIdentifiers.trialableWeekly.id
        ) {
            setScreenCover(to: .freePlanPaywall(viewModel: viewModel))
        }
    }
    
    // MARK: - Launch Sequence
    private func startLaunchSequence() async {
        async let splashDelay: Void = delayIfNeeded()
        async let dependencies: Void = setupDependencies()
        _ = await (splashDelay, dependencies)
        
        setupInitialAppState()
    }
    
    private func delayIfNeeded() async {
        guard defaultsManager.getValue(for: .isOnboardingFinished) != true else { return }
        try? await Task.sleep(for: .seconds(SharedAppValues.splashScreenDuration))
    }
    
    private func setupDependencies() async {
        // Prepare async initializations in parallel.
        async let paymentManager = paymentManagerFactory.makePaymentManager()
        async let persistenceManager = LiveBlockItemPersistenceManager(
            blockItemStore: persistenceStoreFactory.makeBlockItemStore(),
            deviceActivityCenterManager: LiveDeviceActivityCenterManager()
        )
        
        // Resolve dependencies.
        let resolvedPaymentManager = await paymentManager
        let resolvedPersistenceManager = await persistenceManager
        
        // Assign to properties.
        self.paymentManager = resolvedPaymentManager
        self.superPaywallVM = SuperPaywallViewModel(paymentManager: resolvedPaymentManager)
        self.blockItemPersistenceManager = resolvedPersistenceManager
        self.deviceActivityRegistrar = LiveDeviceActivityRegistrar(
            blockItemPersistenceManager: resolvedPersistenceManager,
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
    
    private func makeOnboardingFlowCoordinatorViewModel() -> OnboardingFlowCoordinatorViewModel {
        OnboardingFlowCoordinatorViewModel(appFlowDelegate: self)
    }
    
    private func makeMainFlowCoordinatorViewModel() -> MainFlowCoordinatorViewModel? {
        guard let blockItemPersistenceManager,
              let deviceActivityRegistrar,
              let paymentManager else {
            return nil
        }
        
        return MainFlowCoordinatorViewModel(
            state: .init(currentTabScreen: .none, proState: paymentManager.state),
            proState: paymentManager.state,
            deviceActivityRegistrar: deviceActivityRegistrar,
            blockItemPersistenceManager: blockItemPersistenceManager,
            paywallPresenter: paywallPresenter
        )
    }
    
    // Paywalls
    private func makeFreePlanUpgradeViewModel(requestedProductID: String) -> FreePlanUpgradeViewModel? {
        guard let superPaywallVM, let paymentManager else { return nil }
        
        return FreePlanUpgradeViewModel(
            state: .init(requestedProductID: requestedProductID, proState: paymentManager.state),
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
    }
    
    private func makeOnboardingPaywallViewModel(requestedProductID: String) -> OnboardingPaywallViewModel? {
        guard let superPaywallVM, let paymentManager else { return nil }
        
        return OnboardingPaywallViewModel(
            state: .init(requestedProductID: requestedProductID, proState: paymentManager.state),
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
    }
    
    private func makePlanSelectionPaywallViewModel() -> PlanSelectionPaywallViewModel? {
        guard let superPaywallVM, let paymentManager else { return nil }
        
        return PlanSelectionPaywallViewModel(
            state: .init(proState: paymentManager.state),
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
    }
}

// MARK: - MainFlowNavigationDelegate
extension AppFlowCoordinatorViewModel: PaywallPresenterDelegate {
    func didRequestPlanSelectionPaywall() {
        
        /// - Analytics
        analyticsManager.logEvent(name: "paywall_request_plan_selection", parameters: nil)
        
        if let viewModel = makePlanSelectionPaywallViewModel() {
            setScreenCover(to: .planSelectionPaywall(viewModel: viewModel))
        }
    }
    
    func didRequestFreePlanPaywall() {
        
        /// - Analytics
        analyticsManager.logEvent(name: "paywall_request_free_plan", parameters: nil)
        
        if let viewModel = makeFreePlanUpgradeViewModel(
            requestedProductID: StoreKitProductIdentifiers.trialableWeekly.id
        ) {
            setScreenCover(to: .freePlanPaywall(viewModel: viewModel))
        }
    }
    
    func didRequestOnboardingPaywall() {
        
        /// - Analytics
        analyticsManager.logEvent(name: "paywall_request_onboarding", parameters: nil)
        
        if let viewModel = makeOnboardingPaywallViewModel(
            requestedProductID: StoreKitProductIdentifiers.trialableWeekly.id
        ) {
            setScreenCover(to: .onboardingPaywall(viewModel: viewModel))
        }
    }
}

// MARK: - OnboardingFlowNavigationDelegate
extension AppFlowCoordinatorViewModel: OnboardingFlowNavigationDelegate {
    func didFinishOnboarding() {
        defaultsManager.setValue(for: .isOnboardingFinished, to: true)
        
        /// - Analytics
        analyticsManager.logEvent(name: "onboarding_flow_finished", parameters: nil)
        
        if let mainVM = makeMainFlowCoordinatorViewModel() {
            setStateFlow(to: .main(viewModel: mainVM))
            
            if let onboardingPaywallVM = makeOnboardingPaywallViewModel(
                requestedProductID: StoreKitProductIdentifiers.trialableWeekly.id
            ) {
                setScreenCover(to: .onboardingPaywall(viewModel: onboardingPaywallVM))
            }
        }
    }
}

// MARK: - PaywallNavigationDelegate
extension AppFlowCoordinatorViewModel: PaywallNavigationDelegate {
    func paywallDidRequestPlanSelection() {
        
        /// - Analytics
        analyticsManager.logEvent(name: "paywall_request_plan_selection_from_other_paywall", parameters: nil)
        
        if let viewModel = makePlanSelectionPaywallViewModel() {
            setScreenCover(to: .planSelectionPaywall(viewModel: viewModel))
        }
    }
    
    func paywallDidRequestDismissal() {
        setScreenCover(to: nil)
    }
}
