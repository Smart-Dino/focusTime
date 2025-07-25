//
//  FocusSessionView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI
import FocusTimeUI

struct FocusSessionView: View {
    
    @State private var viewModel: FocusSessionViewModel
    
    init(viewModel: FocusSessionViewModel = FocusSessionViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {

        ScrollView {
            VStack(spacing: Constants.Layout.mainVStackSpacing) {
                ScheduleConfigurationView(
                    configuration: .binding(
                        get: viewModel.state.scheduleConfiguration,
                        set: viewModel.set(scheduleConfiguration:)
                    ),
                    actions: .init(
                        onDurationTap: viewModel.presentDurationPicker,
                        onStartTimeTap: viewModel.presentStartTimePicker,
                        onEndTimeTap: viewModel.presentEndTimePicker,
                        onAppsBlockedTap: viewModel.presentAppBlockerSheet,
                        onScheduledDaysTap: {},
                        onEmojiTapped: viewModel.handlePresetIconTap
                    ),
                    isEmojiTextFieldFocused: viewModel.state.isEmojiTextFieldFocused,

                )
                
                FocusPresetGridView(
                    presets: viewModel.state.presets,
                    selectedPreset: .binding(
                        get: viewModel.state.scheduleConfiguration.selectedPreset,
                        set: viewModel.setScheduledConfiguration(selectedPreset:)
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
        
        // MARK: - Consolidated Sheet Presentation
        .sheet(
            item: .binding(
                get: viewModel.state.activeSheet,
                set: viewModel.needToDismissSheet
            )
        ) { sheetType in
            switch sheetType {
            case .durationPicker:
                DurationPickerSheetView(
                    hours: .binding(
                        get: viewModel.state.scheduleConfiguration.selectedHours,
                        set: viewModel.setScheduledConfiguration(hours:)
                    ),
                    minutes: .binding(
                        get: viewModel.state.scheduleConfiguration.selectedMinutes,
                        set: viewModel.setScheduledConfiguration(minutes:)
                    )
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
                
            case .startTimePicker:
                TimePickerSheetView(
                    selectedDate: .binding(
                        get: viewModel.state.scheduleConfiguration.startTime,
                        set: viewModel.set(startTime:)
                    ),
                    title: TimePickerConstants.Strings.startTimeTitle,
                    subtitle: TimePickerConstants.Strings.startTimeSubtitle
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
                
            case .endTimePicker:
                TimePickerSheetView(
                    selectedDate: .binding(
                        get: viewModel.state.scheduleConfiguration.endTime,
                        set: viewModel.set(endTime:)
                    ),
                    title: TimePickerConstants.Strings.endTimeTitle,
                    subtitle: TimePickerConstants.Strings.endTimeSubtitle
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
                
            case .appBlockerSheet:
#warning("Change ContentView with actual view")
                FocusPresetGridView(
                    presets: viewModel.state.presets,
                    selectedPreset: .binding(
                        get: viewModel.state.scheduleConfiguration.selectedPreset,
                        set: viewModel.setScheduledConfiguration(selectedPreset:)
                    )
                )
                .presentationDetents([.medium, .large])
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
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
