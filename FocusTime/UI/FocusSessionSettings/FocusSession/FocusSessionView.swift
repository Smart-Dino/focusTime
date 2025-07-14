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
    @State private var sheetDurationViewModel: DurationPickerSheetViewModel?
    
    init(viewModel: FocusSessionViewModel = FocusSessionViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: Constants.Layout.mainVStackSpacing) {
                        ScheduleConfigurationView(
                            configuration: $viewModel.state.scheduleConfiguration,
                            actions: .init(
                                onDurationTap: viewModel.presentDurationPicker,
                                onStartTimeTap: viewModel.presentStartTimePicker,
                                onEndTimeTap: viewModel.presentEndTimePicker,
                                onAppsBlockedTap: viewModel.presentAppBlockerSheet,
                                onScheduledDaysTap: {}
                            )
                        )
                        
                        FocusPresetGridView(
                            presets: viewModel.presets,
                            selectedPreset: $viewModel.state.scheduleConfiguration.selectedPreset
                        )
                    }
                    .padding(.vertical)
                }
            }
            .containerRelativeFrame([.horizontal])
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
                .disabled(!viewModel.isStartButtonEnabled)
            }
            .containerRelativeFrame([.horizontal])
            
            // MARK: - Consolidated Sheet Presentation
            .sheet(item: $viewModel.state.activeSheet) { sheetType in
                switch sheetType {
                case .durationPicker:
                    if let sheetDurationViewModel {
                        DurationPickerSheetView(viewModel: sheetDurationViewModel)
                            .presentationDetents([.height(Constants.Layout.sheetHeight)])
                            .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
                            .onDisappear {
                                viewModel.state.scheduleConfiguration.selectedHours = sheetDurationViewModel.hours
                                viewModel.state.scheduleConfiguration.selectedMinutes = sheetDurationViewModel.minutes
                                self.sheetDurationViewModel = nil
                                viewModel.state.activeSheet = nil
                            }
                    } else {
                        Text(Constants.Strings.durationPickerSheetErrorTitle)
                    }
                    
                case .startTimePicker:
                    TimePickerSheetView(
                        selectedDate: $viewModel.state.scheduleConfiguration.startTime,
                        title: TimePickerConstants.Strings.startTimeTitle,
                        subtitle: TimePickerConstants.Strings.startTimeSubtitle
                    )
                    .presentationDetents([.height(Constants.Layout.sheetHeight)])
                    .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
                    
                case .endTimePicker:
                    TimePickerSheetView(
                        selectedDate: $viewModel.state.scheduleConfiguration.endTime,
                        title: TimePickerConstants.Strings.endTimeTitle,
                        subtitle: TimePickerConstants.Strings.endTimeSubtitle
                    )
                    .presentationDetents([.height(Constants.Layout.sheetHeight)])
                    .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
                    
                case .appBlockerSheet:
#warning("Change ContentView with actual view")
                    FocusPresetGridView(
                        presets: viewModel.presets,
                        selectedPreset: $viewModel.state.scheduleConfiguration.selectedPreset
                    )
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
                }
            }
            .preferredColorScheme(.dark)
            .onChange(of: viewModel.state.activeSheet) { oldValue, newValue in
                if newValue == .durationPicker && self.sheetDurationViewModel == nil {
                    self.sheetDurationViewModel = DurationPickerSheetViewModel(hours: viewModel.state.scheduleConfiguration.selectedHours, minutes: viewModel.state.scheduleConfiguration.selectedMinutes)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    FocusSessionView()
}
