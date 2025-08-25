//
//  FocusSessionView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI
import FocusTimeUI

struct FocusSessionView: View {
    //MARK: - Properties
    @State private var viewModel: FocusSessionViewModel
    
    //MARK: - Initializer
    init(viewModel: FocusSessionViewModel = FocusSessionViewModel()) {
        self.viewModel = viewModel
    }
    
    //MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.Layout.mainVStackSpacing) {
                ScheduleConfigurationView(viewModel: viewModel.state.scheduleConfigViewModel)
                
                FocusPresetGridView(
                    presets: viewModel.state.presets,
                    selectedPreset: .binding(
                        get: viewModel.state.selectedPreset,
                        set: viewModel.setSelectedPreset(selectedPreset:)
                    )
                )
            }
            .padding(.vertical)
        }
        .gradientBackground()
        .navigationTitle(Constants.Strings.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                viewModel.startTapped()
            } label: {
                Label(Constants.Strings.startButtonTitle, systemImage: Constants.Symbols.startButtonIcon)
            }
            .buttonStyle(FTPrimaryButtonStyle())
            .padding(.horizontal, Constants.Layout.floatingButtonHorizontalPadding)
            .disabled(!viewModel.state.isStartButtonEnabled)
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        FocusSessionView()
    }
}
