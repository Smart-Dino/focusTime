//
//  FocusSessionViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI

// MARK: - Focus Session Mode
enum FocusSessionMode: Equatable {
    case startFocusing
    case addBlockList
    case addScheduledBlockList
    case editBlockList(_ block: ProtectedBlockItem)
}

// MARK: - Focus Session ViewModel
@Observable
@MainActor
final class FocusSessionViewModel {

    // MARK: - State
    @MainActor
    struct State {
        // MARK: Properties
        let mode: FocusSessionMode
        let proState: ProState
        let presets: [FocusPreset] = FocusPreset.allCases
        var scheduleConfigViewModel: ScheduleConfigurationViewModel
        
        // MARK: View State
        var error: Error?
        var isDeletionAlertPresented = false
        var emojiFieldIsFocused = false
        var shouldDismiss = false
        
        // MARK: Computed Properties
        var isStartButtonDisplayed: Bool {
            mode == .startFocusing
        }
        
        var isSavingButtonsEnabled: Bool {
            let nameFilled = !scheduleConfigViewModel.state.blockItem.name
                .trimmingCharacters(in: .whitespaces).isEmpty
            
            let emojiFilled = !scheduleConfigViewModel.state.blockItem.emoji
                .trimmingCharacters(in: .whitespaces).isEmpty
            
            let daysHasAtLeastOneDay = !scheduleConfigViewModel.state.blockItem.days.isEmpty
            
            return nameFilled && emojiFilled && daysHasAtLeastOneDay
        }
        
        var selectedPreset: FocusPreset? {
            let name = scheduleConfigViewModel.state.blockItem.name
            let emoji = scheduleConfigViewModel.state.blockItem.emoji
            return FocusPreset.getPreset(for: name, emoji: emoji)
        }
        
        var selectedEmoji: String {
            scheduleConfigViewModel.state.blockItem.emoji
        }
        
        var isDurationSchedule: Bool {
            if case .duration = scheduleConfigViewModel.state.blockItem.type {
                return true
            }
            return false
        }
        
        var isScheduled: Bool {
            if case .scheduled = scheduleConfigViewModel.state.blockItem.type {
                return true
            }
            return false
        }
        
        var isItemScheduled: Bool {
            scheduleConfigViewModel.state.blockItem.isScheduled
        }
    }
    
    // MARK: - Properties
    private(set) var state: State
    private var analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()
    
    // MARK: Dependencies
    private let paywallPresenter: PaywallPresenter
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    
    // MARK: - Initializer
    init(
        mode: FocusSessionMode,
        proState: ProState,
        paywallPresenter: PaywallPresenter,
        blockItemPersistenceManager: BlockItemPersistenceManager,
        deviceActivityRegistrar: DeviceActivityRegistrar
    ) {
        self.paywallPresenter = paywallPresenter
        self.blockItemPersistenceManager = blockItemPersistenceManager
        self.deviceActivityRegistrar = deviceActivityRegistrar
        
        let scheduleConfigViewModel = Self.makeScheduleConfigurationViewModel(
            mode: mode,
            proState: proState,
            paywallPresenter: paywallPresenter,
            deviceActivityRegistrar: deviceActivityRegistrar,
            blockItemPersistenceManager: blockItemPersistenceManager
        )
        
        self.state = State(
            mode: mode,
            proState: proState,
            scheduleConfigViewModel: scheduleConfigViewModel
        )
        
        self.state.scheduleConfigViewModel.delegate = self
    }
    
    // MARK: - Public Intents
    
    // MARK: Primary Actions
    func saveTapped() {
        Task {
            do {
                switch state.mode {
                case .startFocusing, .addScheduledBlockList:
                    guard await canAddMoreItems() else {
                        paywallPresenter.requestOnboarding()
                        return
                    }
                    let item = try await saveSelectedItemToStorage(isTemporary: false)
                    try await deviceActivityRegistrar.registerActivity(during: item)
                    
                case .addBlockList:
                    _ = try await saveSelectedItemToStorage(isTemporary: false)
                    
                case .editBlockList:
                    try await blockItemPersistenceManager.editBlockItem(
                        blockItem: state.scheduleConfigViewModel.state.blockItem
                    )
                }
                dismiss()
            } catch {
                state.error = error
            }
        }
    }
    
    func startTapped() {
        // MARK: - Analytics
        state.scheduleConfigViewModel.refreshBlockItem()
        
        let configState = state.scheduleConfigViewModel.state
        
        let parameters: [String: Any] = [
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.presetName: state.selectedPreset?.name ?? "Custom",
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.durationHours: configState.durationHours,
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.durationMinutes: configState.durationMinutes,
            FocusSessionView.Constants.ScheduleSessionAnalyticsParameterKey.isScheduled: configState.isScheduledForLater
        ]
        
        analyticsManager.logEvent(
            name: FocusSessionView.Constants.ScheduleSessionAnalyticsKeys.startButtonTapped.rawValue,
            parameters: parameters
        )
        
        // MARK: - Functionality
        Task {
            do {
                let savedItem = try await saveSelectedItemToStorage(isTemporary: true)
                try await deviceActivityRegistrar.registerActivity(during: savedItem)
                dismiss()
            } catch {
                state.error = error
            }
        }
    }
    
    func startFocusingTapped() {
        Task {
            do {
                guard await canAddMoreItems() else {
                    paywallPresenter.requestOnboarding()
                    return
                }
                
                let scheduleItem = state.scheduleConfigViewModel.state.blockItem
                if state.isItemScheduled {
                    try await deviceActivityRegistrar.unregisterActivity(during: scheduleItem)
                } else {
                    try await deviceActivityRegistrar.registerActivity(during: scheduleItem)
                }
                dismiss()
            } catch {
                state.error = error
            }
        }
    }
    
    func deleteButtonTapped() {
        Task {
            do {
                let item = state.scheduleConfigViewModel.state.blockItem
                try await blockItemPersistenceManager.delete(blockItem: item)
                setDeletionAlertPresentation(false)
                dismiss()
            } catch {
                state.error = error
            }
        }
    }
    
    // MARK: State Modifiers
    func setDeletionAlertPresentation(_ isPresented: Bool) {
        state.isDeletionAlertPresented = isPresented
    }
    
    func setErrorVisibility(_ isVisible: Bool) {
        if !isVisible {
            state.error = nil
        }
    }
    
    func setSelectedEmoji(_ emoji: String) {
        state.scheduleConfigViewModel.setCustomPresetEmoji(emoji: emoji)
    }
    
    func setSelectedPreset(selectedPreset: FocusPreset?) {
        state.scheduleConfigViewModel.setSelectedPreset(selectedPreset: selectedPreset)
    }
    
    // MARK: Navigation
    func dismiss() {
        state.shouldDismiss = true
    }
    
    // MARK: - Private Helpers
    private func saveSelectedItemToStorage(isTemporary: Bool) async throws -> ProtectedBlockItem {
        var item = state.scheduleConfigViewModel.state.blockItem
        
        if isTemporary {
            item.isTemporary = .oneTimeBlock
        }
        
        try await blockItemPersistenceManager.insert(&item)
        return item
    }
    
    private func canAddMoreItems() async -> Bool {
        let isPro = state.proState.status.isPro
        let trackedItemsCount = await deviceActivityRegistrar.trackedActivities.count
        let limit = SharedAppValues.FreeUserLimits.maximumAmountOfBlocks
        
        if isPro {
            return true
        } else {
            return trackedItemsCount < limit
        }
    }

    private static func makeScheduleConfigurationViewModel(
        mode: FocusSessionMode,
        proState: ProState,
        paywallPresenter: PaywallPresenter,
        deviceActivityRegistrar: DeviceActivityRegistrar,
        blockItemPersistenceManager: BlockItemPersistenceManager
    ) -> ScheduleConfigurationViewModel {
        switch mode {
        case .startFocusing, .addBlockList:
            return ScheduleConfigurationViewModel(
                state: .init(proState: proState),
                paywallPresenter: paywallPresenter,
                deviceActivityRegistrar: deviceActivityRegistrar,
                blockItemPersistenceManager: blockItemPersistenceManager
            )
        case .addScheduledBlockList:
            return ScheduleConfigurationViewModel(
                state: .init(proState: proState, isScheduledForLater: true),
                paywallPresenter: paywallPresenter,
                deviceActivityRegistrar: deviceActivityRegistrar,
                blockItemPersistenceManager: blockItemPersistenceManager
            )
        case .editBlockList(let block):
            let isScheduledForLater = if case .scheduled = block.type { true } else { false }
            
            return ScheduleConfigurationViewModel(
                state: .init(proState: proState, blockItem: block, isScheduledForLater: isScheduledForLater),
                paywallPresenter: paywallPresenter,
                deviceActivityRegistrar: deviceActivityRegistrar,
                blockItemPersistenceManager: blockItemPersistenceManager
            )
        }
    }
}

// MARK: - ScheduleConfigurationDelegate
extension FocusSessionViewModel: ScheduleConfigurationDelegate {
    func didChangeEmojiFieldFocusState(isFocused: Bool) {
        state.emojiFieldIsFocused = isFocused
    }
}
