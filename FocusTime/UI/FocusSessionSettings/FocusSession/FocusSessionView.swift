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
                
                if viewModel.state.isInEditingMode {
                    Button(role: .destructive) {
                        #warning("No implementation")
                    } label: {
                        Text("Delete Preset")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .rowStyle(height: 50)
                            .padding(.horizontal)
                            .contentShape(.rect)
                    }
                }
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
                    VStack {
                        // Start Focusing button (only in editing + duration mode)
                        if viewModel.state.isInEditingMode && viewModel.state.isDurationSchedule {
                            Button("Start Focusing") {
                                #warning("No implementation")
                            }
                            .buttonStyle(.ftAction)
                        }
                        
                        // Save button (editing mode or scheduled)
                        if viewModel.state.isInEditingMode || viewModel.state.isScheduled {
                            Button("Save") {
                                #warning("No implementation")
                            }
                            .buttonStyle(.ftPrimary)
                        } else {
                            // Default Start button
                            Button {
                                viewModel.startTapped()
                            } label: {
                                Label(Constants.Strings.startButtonTitle, systemImage: Constants.Symbols.startButtonIcon)
                            }
                            .buttonStyle(.ftPrimary)
                            .disabled(!viewModel.state.isStartButtonEnabled)
                        }
                    }
                }
            }
            .padding(Constants.Layout.floatingButtonPadding)
            .backgroundGradientFade()
        }
        .preferredColorScheme(.dark)
    }
    
    //MARK: - Initializer
    init(viewModel: FocusSessionViewModel = FocusSessionViewModel()) {
        self.viewModel = viewModel
    }
    
}

// MARK: - Preview
#Preview("Creation mode") {
    NavigationStack {
        FocusSessionView()
    }
}

#Preview("Editing mode duration") {
    NavigationStack {
        FocusSessionView(
            viewModel: FocusSessionViewModel(
                state: .init(blockItem: ProtectedBlockItem.mockDuration)
            )
        )
    }
}

#Preview("Editing mode scheduled") {
    NavigationStack {
        FocusSessionView(
            viewModel: FocusSessionViewModel(
                state: .init(blockItem: ProtectedBlockItem.mockScheduled)
            )
        )
    }
}
