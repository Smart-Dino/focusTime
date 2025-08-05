//
//  LaunchFlowView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.08.2025.
//

import SwiftUI
import SwiftData

struct LaunchFlowView: View {
    @State private var viewModel: LaunchFlowCoordinatorViewModel = LaunchFlowCoordinatorViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state.currentFlow {
            case .appFlow(let appFlowViewModel):
                AppFlowCoordinatorView(
                    viewModel: appFlowViewModel
                )
            case .splash(let splashScreenViewModel):
                SplashScreenView(
                    viewModel: splashScreenViewModel
                )
            }
        }
        .transition(.opacity)
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(get: {
                viewModel.state.error != nil
            }, set: { isVisible in
                viewModel.setErrorVisibility(isVisible)
            }), actions: {
                // OK dismissal button by default
            }, message: {
                Text(viewModel.state.error?.localizedDescription ?? "")
            }
        )
    }
}

#Preview {
    LaunchFlowView()
}
