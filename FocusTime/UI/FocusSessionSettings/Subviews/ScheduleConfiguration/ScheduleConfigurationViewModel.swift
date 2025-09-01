//
//  ScheduleConfigurationViewModel.swift
//  FocusTime
//
//  Created by Keto Nioradze on 24.07.25.
//

import SwiftUI
import FamilyControls
import ManagedSettings

@MainActor
protocol ScheduleConfigurationDelegate: AnyObject {
    func didChangeEmojiFieldFocusState(isFocused: Bool)
}

@MainActor
@Observable
final class ScheduleConfigurationViewModel {
    
    // MARK: - Enum
    enum ScheduleSheetType: Identifiable, Hashable {
        case durationPicker
        case startTimePicker
        case endTimePicker
        case appBlockerSheet(_ viewModel: BlockListPickerSheetViewModel)
        
        var id: Int { self.hashValue }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .durationPicker:
                hasher.combine(0)
            case .startTimePicker:
                hasher.combine(1)
            case .endTimePicker:
                hasher.combine(2)
            case .appBlockerSheet:
                hasher.combine(3)
            }
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.durationPicker, .durationPicker): true
            case (.startTimePicker, .startTimePicker): true
            case (.endTimePicker, .endTimePicker): true
            case (.appBlockerSheet, .appBlockerSheet): true
            default: false
            }
        }

    }
    
    // MARK: - State
    struct State: Equatable {
        let proState: ProState
        
        var blockItem: ProtectedBlockItem
        var appsTokenSelectionCount: Int {
            blockItem.blockedContent.applicationTokens.count
        }
        var categoriesSelectionCount: Int {
            blockItem.blockedContent.categoryTokens.count
        }
        
        var durationHours: Int
        var durationMinutes: Int
        var startTime: Date
        var endTime: Date
        
        var isScheduledForLater: Bool
        
        var activeSheet: ScheduleSheetType?
        
        init(
            proState: ProState,
            blockItem: ProtectedBlockItem = .default,
            durationHours: Int = ScheduleConfigurationView.Constants.DefaultValues.durationHours,
            durationMinutes: Int = ScheduleConfigurationView.Constants.DefaultValues.durationMinutes,
            startTime: Date = ScheduleConfigurationView.Constants.DefaultValues.startTime,
            endTime: Date = ScheduleConfigurationView.Constants.DefaultValues.endTime,
            activeSheet: ScheduleSheetType? = nil
        ) {
            self.proState = proState
            self.blockItem = blockItem
            self.durationHours = durationHours
            self.durationMinutes = durationMinutes
            self.startTime = startTime
            self.endTime = endTime
            self.activeSheet = activeSheet
            
            switch blockItem.type {
            case .scheduled:
                self.isScheduledForLater = true
            case .duration:
                self.isScheduledForLater = false
            }
        }
    }
    
    // MARK: - Properties
    private(set) var state: State
    
    private let paywallPresenter: PaywallPresenter
    private let deviceActivityRegistrar: DeviceActivityRegistrar
    private let blockItemPersistenceManager: BlockItemPersistenceManager
    weak var delegate: ScheduleConfigurationDelegate?
    private var analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()

    // MARK: - Initializers
    init(
        state: State,
        paywallPresenter: PaywallPresenter,
        deviceActivityRegistrar: DeviceActivityRegistrar,
        blockItemPersistenceManager: BlockItemPersistenceManager
    ) {
        self.state = state
        self.paywallPresenter = paywallPresenter
        self.deviceActivityRegistrar = deviceActivityRegistrar
        self.blockItemPersistenceManager = blockItemPersistenceManager
    }

    // MARK: - Methods
    /// Sets the list name in the state.
    /// - Parameter listName: The new list name.
    func setListName(listName: String) {
        state.blockItem.name = listName
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.setListName.rawValue, parameters: [ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.listname : listName])
    }

    /// Toggles the 'schedule for later' setting.
    /// - Parameter isOn: A boolean indicating whether scheduling for later is active.
    func setScheduleForLater(isOn: Bool) {
        state.isScheduledForLater = isOn
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.scheduledForLaterToggled.rawValue, parameters: [ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.scheduleForLater : isOn])
    }
    
    func updateDelegateEmojiFocusStateStatus(with isFocused: Bool) {
        delegate?.didChangeEmojiFieldFocusState(isFocused: isFocused)
    }

    /// Toggles the selection of a specific weekday for scheduling.
    /// - Parameters:
    ///   - day: The weekday to add or remove.
    ///   - isSelected: A boolean indicating whether the day should be selected.
    func setScheduledDay(_ day: Weekday, isSelected: Bool) {
        if isSelected {
            state.blockItem.days.insert(day)
            analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.scheduledDayAdded.rawValue, parameters: [ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.scheduledDay : day])
        } else {
            state.blockItem.days.remove(day)
            analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.scheduledDayRemoved.rawValue, parameters: [ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.scheduledDay : day])
        }
    }

    /// Sets the custom preset emoji.
    /// - Parameter emoji: The custom emoji string. Only the first character is kept.
    func setCustomPresetEmoji(emoji: String) {
        state.blockItem.emoji = String(emoji.prefix(1))
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.setCustomEmoji.rawValue, parameters: [ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.customEmoji : emoji])
    }
    
    /// Updates the selected hours in the schedule configuration.
    /// - Parameter hours: The number of hours to set for the focus session duration.
    func setHours(hours: Int) {
        state.durationHours = hours
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.setHours.rawValue, parameters: [ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.setHours : hours])
    }

    /// Updates the selected minutes value in the schedule configuration.
    /// - Parameter minutes: The number of minutes to set for the scheduled duration.
    func setMinutes(minutes: Int) {
        state.durationMinutes = minutes
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.setMinutes.rawValue, parameters: [ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.setMinutes : minutes])
    }

    /// Updates the start time in the current schedule configuration.
    /// - Parameter startTime: The new start time to set.
    func setStartTime(startTime: Date) {
        state.startTime = startTime
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.startButtonTapped.rawValue, parameters: [ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.startTime : startTime])
    }

    /// Updates the end time in the current schedule configuration.
    /// - Parameter endTime: The new end time to set.
    func setEndTime(endTime: Date) {
        state.endTime = endTime
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.endButtonTapped.rawValue, parameters: [ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.endTime : endTime])
    }

    /// Updates the selected focus preset in the schedule configuration.
    /// This method is called by the FocusSessionViewModel
    /// to update the child's state based on preset grid selection.
    /// - Parameter selectedPreset: The focus preset to select, or nil triggers a random preset selection.
    func setSelectedPreset(selectedPreset: FocusPreset?) {
        guard let selectedPreset else { return }
        state.blockItem.name = selectedPreset.name
        state.blockItem.emoji = selectedPreset.emoji
        
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.presetSelected.rawValue, parameters: [
            ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.presetName: selectedPreset.name
        ])
    }

    // MARK: - Intents (Sheet Presentation)

    /// Presents the duration picker sheet by setting the active sheet state.
    func presentDurationPicker() {
        state.activeSheet = .durationPicker
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.durationPickerPresented.rawValue, parameters: nil)
    }

    /// Presents the start time picker sheet by setting the active sheet state.
    func presentStartTimePicker() {
        state.activeSheet = .startTimePicker
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.timePickerPresented.rawValue, parameters: [ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.timePickerType : ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.startTime])
    }

    /// Presents the end time picker sheet by setting the active sheet state.
    func presentEndTimePicker() {
        state.activeSheet = .endTimePicker
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.timePickerPresented.rawValue, parameters: [ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.timePickerType : ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsParameterKey.endTime])
    }

    /// Presents the app blocker sheet by setting the active sheet state accordingly.
    func presentAppBlockerSheet() {
        Task {
            try await deviceActivityRegistrar.checkAuth()
            let viewModel = BlockListPickerSheetViewModel(
                deviceActivityRegistrar: deviceActivityRegistrar,
                blockItemPersistenceManager: blockItemPersistenceManager
            )
            viewModel.delegate = self
            
            state.activeSheet = .appBlockerSheet(viewModel)
        }
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.appBlockerSheetPresented.rawValue, parameters: nil)
    }

    /// Dismisses any currently presented sheet by setting the active sheet to nil.
    func dismissSheet(_ sheet: ScheduleSheetType?) {
        state.activeSheet = nil
        analyticsManager.logEvent(name: ScheduleConfigurationView.Constants.ScheduleSessionAnalyticsKeys.dismissSheet.rawValue, parameters: nil)
    }
    
    // MARK: - Logic
    
    /// Clears the emoji associated with the current `BlockItem` if the given
    /// `TextField` is focused.
    ///
    /// - Parameter isTextFieldFocused: A Boolean value indicating whether
    ///   the `TextField` currently has focus. If `false`, the emoji will not
    ///   be cleared.
    /// - Note: A short asynchronous delay is introduced before clearing to
    ///   avoid conflicts with the `TextField`’s binding, which updates its
    ///   value immediately on tap gestures.
    func clearEmoji(isTextFieldFocused: Bool) {
        guard isTextFieldFocused else { return }
        Task {
            try? await Task.sleep(for: .milliseconds(1))
            state.blockItem.emoji = String()
        }
    }


    /// Updates the `blockItem` type based on the current scheduling state.
    /// - If `isScheduledForLater` is `true`, the block item will be updated
    ///   with `scheduled` type, using the provided `startTime` and `endTime`.
    ///   If parsing fails, defaults are applied.
    /// - Otherwise, the block item will be updated with `duration` type,
    ///   calculated from the configured hours and minutes.
    func refreshBlockItem() {
        if state.isScheduledForLater {
            let startTime = try? TimeComponents(from: state.startTime)
            let endTime = try? TimeComponents(from: state.endTime)
            
            state.blockItem.type = .scheduled(
                startTime: startTime ?? .default,
                endTime: endTime ?? .default
            )
        } else {
            let hoursAsSeconds = state.durationHours * 60 * 60
            let minutesAsSeconds = state.durationMinutes * 60
            let totalSeconds = hoursAsSeconds + minutesAsSeconds
            
            state.blockItem.type = .duration(
                duration: DurationComponents(seconds: totalSeconds)
            )
        }
    }
    
    func showPaywallIfNeeded() {
        if !checkIfCanSetCustomApps() { paywallPresenter.requestOnboarding() }
    }
    
    private func checkIfCanSetCustomApps() -> Bool {
        return state.proState.status.isPro
    }

}

extension ScheduleConfigurationViewModel: BlockListPickerSheetDelegate {
    func didFinishSelectionWith(_ selection: FamilyActivitySelection) {
        state.blockItem.blockedContent = selection
    }
}
