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
    @Environment(\.dismiss) var dismiss
    @State var viewModel: FocusSessionViewModel
    
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
                
                if case .editBlockList = viewModel.state.mode {
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
        .alert(
            SharedConstants.Strings.errorHeader,
            isPresented: Binding(
                get: { viewModel.state.error != nil },
                set: { viewModel.setErrorVisibility($0) }
            ),
            actions: { /* OK dismissal button by default */ },
            message: { Text(viewModel.state.error?.localizedDescription ?? String()) }
        )
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
                        if case .editBlockList = viewModel.state.mode, viewModel.state.isDurationSchedule {
                            Button("Start Focusing") {
                                #warning("No implementation")
                            }
                            .buttonStyle(.ftAction)
                        }
                        
                        // Save button (editing mode or scheduled)
                        if !viewModel.state.isStartButtonDisplayed || viewModel.state.isScheduled {
                            Button("Save") {
                                Task {
                                    try await viewModel.saveTapped()
                                    dismiss.callAsFunction()
                                }
                            }
                            .buttonStyle(.ftPrimary)
                        } else {
                            // Default Start button
                            Button {
                                Task {
                                    try await viewModel.startTapped()
                                    dismiss.callAsFunction()
                                }
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
}

// MARK: - Preview
#Preview("Creation mode") {
    let manager = PreviewData.mockBlockItemPersistenceManager
    let registrar = LiveDeviceActivityRegistrar(
        blockItemPersistenceManager: manager,
        shieldManager: LiveShieldManager()
    )
    let viewModel = FocusSessionViewModel(
        mode: .addBlockList,
        blockItemPersistenceManager: manager,
        deviceActivityRegistrar: registrar
    )
    
    NavigationStack {
        FocusSessionView(viewModel: viewModel)
    }
}

#Preview("Start focusing mode") {
    let manager = PreviewData.mockBlockItemPersistenceManager
    let registrar = LiveDeviceActivityRegistrar(
        blockItemPersistenceManager: manager,
        shieldManager: LiveShieldManager()
    )
    let viewModel = FocusSessionViewModel(
        mode: .startFocusing,
        blockItemPersistenceManager: manager,
        deviceActivityRegistrar: registrar
    )
    
    return NavigationStack {
        FocusSessionView(viewModel: viewModel)
    }
}

#Preview("Editing mode duration") {
    let manager = PreviewData.mockBlockItemPersistenceManager
    let registrar = LiveDeviceActivityRegistrar(
        blockItemPersistenceManager: manager,
        shieldManager: LiveShieldManager()
    )
    let viewModel = FocusSessionViewModel(
        mode: .editBlockList(ProtectedBlockItem.mockDuration),
        blockItemPersistenceManager: manager,
        deviceActivityRegistrar: registrar
    )
    
    return NavigationStack {
        FocusSessionView(viewModel: viewModel)
    }
}

#Preview("Editing mode scheduled") {
    let manager = PreviewData.mockBlockItemPersistenceManager
    let registrar = LiveDeviceActivityRegistrar(
        blockItemPersistenceManager: manager,
        shieldManager: LiveShieldManager()
    )
    let viewModel = FocusSessionViewModel(
        mode: .editBlockList(ProtectedBlockItem.mockScheduled),
        blockItemPersistenceManager: manager,
        deviceActivityRegistrar: registrar
    )
    
    return NavigationStack {
        FocusSessionView(viewModel: viewModel)
    }
}
