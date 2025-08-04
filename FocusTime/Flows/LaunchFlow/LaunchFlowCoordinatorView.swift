//
//  LaunchFlowView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.08.2025.
//

import SwiftUI
import SwiftData

#warning("When creating a splash screen make sure to handle ModelContainer errors!")

struct LaunchFlowView: View {
    @State private var viewModel: LaunchFlowCoordinatorViewModel = LaunchFlowCoordinatorViewModel()
    
    var body: some View {
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
}

#Preview {
    LaunchFlowView()
}
