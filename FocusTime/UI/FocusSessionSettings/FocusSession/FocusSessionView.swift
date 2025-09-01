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
                        viewModel.setDeletionAlertPresentation(true)
                    } label: {
                        Text(Constants.Strings.deletePresetButtonTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .rowStyle(height: Constants.Layout.deleteButtonHeight)
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
        .alert(
            Constants.Strings.deleteConfirmationAlertTitle,
            isPresented: Binding(
                get: { viewModel.state.isDeletionAlertPresented },
                set: { viewModel.setDeletionAlertPresentation($0) }
            ),
            actions: {
                Button(Constants.Strings.deleteConfirmationAlertDeleteButton, role: .destructive) {
                    viewModel.deleteButtonTapped()
                }
                Button(Constants.Strings.deleteConfirmationAlertCancelButton, role: .cancel) {
                    viewModel.setDeletionAlertPresentation(false)
                }
            },
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
                            Button(Constants.Strings.startFocusingButtonTitle) {
                                viewModel.startFocusingTapped()
                            }
                            .buttonStyle(.ftAction)
                        } else if case .editBlockList = viewModel.state.mode, viewModel.state.isScheduled {
                            Button(viewModel.state.isItemScheduled ? Constants.Strings.deactivateScheduleButtonTitle : Constants.Strings.activateScheduleButtonTitle) {
                                viewModel.startFocusingTapped()
                            }
                            .buttonStyle(.ftAction)
                        }
                        
                        // Save button (editing mode or scheduled)
                        if !viewModel.state.isStartButtonDisplayed || viewModel.state.isScheduled {
                            Button(Constants.Strings.saveButtonTitle) {
                                viewModel.saveTapped()
                            }
                            .buttonStyle(.ftPrimary)
                            .disabled(!viewModel.state.isSavingButtonsEnabled)
                        } else {
                            // Default Start button
                            Button {
                                viewModel.startTapped()
                            } label: {
                                Label(Constants.Strings.startButtonTitle, systemImage: Constants.Symbols.startButtonIcon)
                            }
                            .buttonStyle(.ftPrimary)
                            .disabled(!viewModel.state.isSavingButtonsEnabled)
                        }
                    }
                }
            }
            .padding(Constants.Layout.floatingButtonPadding)
            .backgroundGradientFade()
        }
        .preferredColorScheme(.dark)
        .onChange(of: viewModel.state.shouldDismiss) {
            if viewModel.state.shouldDismiss {
                dismiss.callAsFunction()
            }
        }
    }
}

// MARK: - Preview
#Preview("Creation mode") {
    let manager = PreviewData.mockBlockItemPersistenceManager
    let registrar = PreviewData.mockActivityRegistrar
    let proState = MockPaymentManagerWithPurchaseError().state
    
    let viewModel = FocusSessionViewModel(
        mode: .addBlockList,
        proState: proState,
        paywallPresenter: LivePaywallPresenter(),
        blockItemPersistenceManager: manager,
        deviceActivityRegistrar: registrar
    )
    
    NavigationStack {
        FocusSessionView(viewModel: viewModel)
    }
}

#Preview("Start focusing mode") {
    let manager = PreviewData.mockBlockItemPersistenceManager
    let registrar = PreviewData.mockActivityRegistrar
    let proState = MockPaymentManagerWithPurchaseError().state
    
    let viewModel = FocusSessionViewModel(
        mode: .startFocusing,
        proState: proState,
        paywallPresenter: LivePaywallPresenter(),
        blockItemPersistenceManager: manager,
        deviceActivityRegistrar: registrar
    )
    
     NavigationStack {
        FocusSessionView(viewModel: viewModel)
    }
}

#Preview("Editing mode duration") {
    let manager = PreviewData.mockBlockItemPersistenceManager
    let registrar = PreviewData.mockActivityRegistrar
    let proState = MockPaymentManagerWithPurchaseError().state
    
    let viewModel = FocusSessionViewModel(
        mode: .editBlockList(ProtectedBlockItem.mockDuration),
        proState: proState,
        paywallPresenter: LivePaywallPresenter(),
        blockItemPersistenceManager: manager,
        deviceActivityRegistrar: registrar
    )
    
    NavigationStack {
        FocusSessionView(viewModel: viewModel)
    }
}

#Preview("Editing mode scheduled") {
    let manager = PreviewData.mockBlockItemPersistenceManager
    let registrar = PreviewData.mockActivityRegistrar
    let proState = MockPaymentManagerWithPurchaseError().state
    
    let viewModel = FocusSessionViewModel(
        mode: .editBlockList(ProtectedBlockItem.mockScheduled),
        proState: proState,
        paywallPresenter: LivePaywallPresenter(),
        blockItemPersistenceManager: manager,
        deviceActivityRegistrar: registrar
    )
    
    NavigationStack {
        FocusSessionView(viewModel: viewModel)
    }
}
