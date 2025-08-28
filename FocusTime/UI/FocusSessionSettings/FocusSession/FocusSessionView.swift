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
            Group {
                if viewModel.state.emojiFieldIsFocused {
                    FTEmojiPicker(
                        selectedEmoji: .binding(
                            get: viewModel.state.selectedEmoji,
                            set: viewModel.setSelectedEmoji(_:)
                        ),
                        emojis: Constants.Strings.emojis
                    )
                } else {
                    Button {
                        viewModel.startTapped()
                    } label: {
                        Label(Constants.Strings.startButtonTitle, systemImage: Constants.Symbols.startButtonIcon)
                    }
                    .buttonStyle(FTPrimaryButtonStyle())
                    .disabled(!viewModel.state.isStartButtonEnabled)
                }
            }
            .padding(Constants.Layout.floatingButtonPadding)
        }
        .preferredColorScheme(.dark)
    }
    
    //MARK: - Initializer
    init(viewModel: FocusSessionViewModel = FocusSessionViewModel()) {
        self.viewModel = viewModel
    }
    
}

// MARK: - Preview
#Preview {
    NavigationStack {
        FocusSessionView()
    }
}
