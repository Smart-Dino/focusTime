//
//  AppFlowCoordinatorView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 31.07.2025.
//

import SwiftUI

struct AppFlowCoordinatorView: View {
    @State var viewModel: AppFlowCoordinatorViewModel
    
    var body: some View {
        switch viewModel.state.currentFlow {
        case .onboarding(let onboardingFlowViewModel):
            OnboardingFlowCoordinatorView(viewModel: onboardingFlowViewModel)
        case .main(let mainFlowViewModel):
            MainFlowCoordinatorView(viewModel: mainFlowViewModel)
        }
        
        EmptyView()
        
    }
}

#Preview {
    let defaultsManager = LiveDefaultsManager()
    AppFlowCoordinatorView(
        viewModel: .init(
            defaultsManager: defaultsManager,
            modelContainer: PreviewData.memoryOnlyModelContainer
        )
    )
}
