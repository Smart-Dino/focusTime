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
            if let appFlowCoordinatorViewModel = viewModel.state.appFlowCoordinatorViewModel {
                AppFlowCoordinatorView(
                    viewModel: appFlowCoordinatorViewModel
                )
            } else {
                #warning("Implement splash screen")
                ProgressView()
                Text("Hang on...")
            }
        }
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(get: {
                viewModel.state.error != nil
            }, set: { showError in
                viewModel.keepShowingError(showError: showError)
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
