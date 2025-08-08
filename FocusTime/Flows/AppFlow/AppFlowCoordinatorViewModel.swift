//
//  AppFlowCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import SwiftUI
import SwiftData
import Foundation

// MARK: - Screens
enum AppScreen: Equatable, Hashable {
    case onboarding(viewModel: OnboardingFlowCoordinatorViewModel)
    case main(viewModel: MainFlowCoordinatorViewModel)
    
    static func == (lhs: AppScreen, rhs: AppScreen) -> Bool {
        switch (lhs, rhs) {
        case (.onboarding, .onboarding): true
        case (.main, .main):             true
        default:                         false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .onboarding: hasher.combine(0)
        case .main: hasher.combine(1)
        }
    }
}

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
        var currentFlow: AppScreen
        var screenCover: AppFullScreenCover?
        
        init(currentFlow: AppScreen) {
            self.currentFlow = currentFlow
        }
    }
    
    private(set) var state: State!
    private let defaultsManager: DefaultsManager
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    private let paymentManager: PaymentManager
    private let superPaywallVM: SuperPaywallViewModel
    
    init(
        defaultsManager: DefaultsManager,
        blockItemPersistenceManager: BlockItemPersistenceManager,
        paymentManager: PaymentManager
    ) {
        self.defaultsManager = defaultsManager
        self.blockItemPersistenceManager = blockItemPersistenceManager
        self.paymentManager = paymentManager
        self.superPaywallVM = SuperPaywallViewModel(paymentManager: paymentManager)
        
        setupInitialAppState()
    }
    
    func setupInitialAppState() {
        let isOnboardingFinished: Bool = defaultsManager.getValue(for: .isOnboardingFinished) ?? false
        
        if !isOnboardingFinished {
            setStateFlow(to: .onboarding(viewModel: makeOnboardingFlowCoordinatorViewModel()))
            return
        }
        
        setStateFlow(to: .main(viewModel: makeMainFlowCoordinatorViewModel()))
    }
    
    func showFreePlanCoverIfNeeded() async {
        guard await !paymentManager.isPro && state.screenCover == nil else { return }
        
        let viewModel = makeFreePlanUpgradeViewModel(
            requestedProductID: StoreKitProductIdentifiers.trialableWeekly.id
        )
        
        setScreenCover(to: .freePlanPaywall(viewModel: viewModel))
    }
    
    func setStateFlow(to screen: AppScreen?) {
        guard let screen else { return }
        if state == nil {
            state = State(currentFlow: screen)
        } else {
            withAnimation {
                state.currentFlow = screen
            }
        }
    }
    
    func setScreenCover(to cover: AppFullScreenCover?) {
        if state.screenCover != cover {
            state.screenCover = cover
        }
    }
    
    // MARK: - Factory methods
    private func makeOnboardingFlowCoordinatorViewModel() -> OnboardingFlowCoordinatorViewModel {
        OnboardingFlowCoordinatorViewModel(appFlowDelegate: self)
    }
    
    private func makeMainFlowCoordinatorViewModel() -> MainFlowCoordinatorViewModel {
        MainFlowCoordinatorViewModel(
            blockItemPersistenceManager: blockItemPersistenceManager,
            appFlowDelegate: self
        )
    }
    
    // Paywalls
    private func makeFreePlanUpgradeViewModel(requestedProductID: String) -> FreePlanUpgradeViewModel {
        FreePlanUpgradeViewModel(
            state: .init(requestedProductID: requestedProductID),
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
    }
    
    private func makeOnboardingPaywallViewModel(requestedProductID: String) -> OnboardingPaywallViewModel {
        OnboardingPaywallViewModel(
            state: .init(requestedProductID: requestedProductID),
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
    }
    
    private func makePlanSelectionPaywallViewModel() -> PlanSelectionPaywallViewModel {
        PlanSelectionPaywallViewModel(
            superPaywallVM: superPaywallVM,
            flowDelegate: self
        )
    }
    
}

// MARK: - MainFlowNavigationDelegate
extension AppFlowCoordinatorViewModel: MainFlowDelegate {
    // MARK: Paywall
    func didRequestPaywallPlanSelection() {
        setScreenCover(to: .planSelectionPaywall(viewModel: makePlanSelectionPaywallViewModel()))
    }
    
    func didRequestPaywallFreePlan() {
        setScreenCover(
            to: .freePlanPaywall(
                viewModel: makeFreePlanUpgradeViewModel(
                    requestedProductID: StoreKitProductIdentifiers.trialableWeekly.id
                )
            )
        )
    }
    
    // MARK: Onboarding
    func didRequestOnboarding() {
        setStateFlow(to: .onboarding(viewModel: makeOnboardingFlowCoordinatorViewModel()))
    }
    
    // MARK: Main Flow
    func didRequestMainFlow() {
        setStateFlow(to: .main(viewModel: makeMainFlowCoordinatorViewModel()))
    }
}

// MARK: - OnboardingFlowNavigationDelegate
extension AppFlowCoordinatorViewModel: OnboardingFlowNavigationDelegate {
    func didFinishOnboarding() {
        defaultsManager.setValue(for: .isOnboardingFinished, to: true)
        let mainVM = makeMainFlowCoordinatorViewModel()
        setStateFlow(to: .main(viewModel: mainVM))
        setScreenCover(
            to: .onboardingPaywall(
                viewModel: makeOnboardingPaywallViewModel(requestedProductID: StoreKitProductIdentifiers.trialableWeekly.id)
            )
        )
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
        setScreenCover(to: .planSelectionPaywall(viewModel: makePlanSelectionPaywallViewModel()))
    }
    
    func paywallDidRequestDismissal() {
        setScreenCover(to: nil)
    }
}
