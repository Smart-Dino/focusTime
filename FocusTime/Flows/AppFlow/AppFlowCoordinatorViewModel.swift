//
//  AppFlowCoordinatorViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import SwiftUI
import SwiftData
import Foundation

enum AppScreens: Equatable, Hashable {
    case onboarding(viewModel: OnboardingFlowCoordinatorViewModel)
    case main(viewModel: MainFlowCoordinatorViewModel)
    
    var id: String {
        switch self {
        case .onboarding:
            return "onboarding"
        case .main:
            return "main"
        }
    }
    
    static func == (lhs: AppScreens, rhs: AppScreens) -> Bool {
        switch (lhs, rhs) {
        case (.onboarding, .onboarding): return true
        case (.main, .main): return true
        default: return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .onboarding: hasher.combine(0)
        case .main: hasher.combine(1)
        }
    }
}

@MainActor
@Observable
final class AppFlowCoordinatorViewModel {
    struct State {
        var currentFlow: AppScreens
        init(currentFlow: AppScreens) {
            self.currentFlow = currentFlow
        }
    }
    
    private(set) var state: State!
    private let defaultsManager: DefaultsManager
    private let modelContainer: ModelContainer
    
    init(
        defaultsManager: DefaultsManager,
        modelContainer: ModelContainer
    ) {
        self.defaultsManager = defaultsManager
        self.modelContainer = modelContainer
        
        let onboardingVM = makeOnboardingFlowCoordinatorViewModel()
        self.state = State(currentFlow: .onboarding(viewModel: onboardingVM))
    }
    
    func setStateFlow(to screen: AppScreens?) {
        if let screen {
            withAnimation {
                state.currentFlow = screen
            }
        }
    }
    
    func setupFlow() {
        let isOnboardingFinished = defaultsManager.getValue(for: .isOnboardingFinished) as? Bool ?? false
        
        if isOnboardingFinished {
            let mainVM = makeMainFlowCoordinatorViewModel()
            setStateFlow(to: .main(viewModel: mainVM))
        }
    }
    
    func makeOnboardingFlowCoordinatorViewModel() -> OnboardingFlowCoordinatorViewModel {
        OnboardingFlowCoordinatorViewModel(delegate: self)
    }
    
    func makeMainFlowCoordinatorViewModel() -> MainFlowCoordinatorViewModel {
        MainFlowCoordinatorViewModel(modelContainer: modelContainer)
    }
}

extension AppFlowCoordinatorViewModel: OnboardingFlowNavigationDelegate {
    func didFinishOnboarding() {
        let mainVM = makeMainFlowCoordinatorViewModel()
        setStateFlow(to: .main(viewModel: mainVM))
    }
}
