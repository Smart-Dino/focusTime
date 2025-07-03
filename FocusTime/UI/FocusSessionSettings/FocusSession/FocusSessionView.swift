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
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: Constants.Layout.mainVStackSpacing) {
                        ScheduleConfigurationView(
                            configuration: $viewModel.state.scheduleConfiguration,
                            onDurationTap: viewModel.presentDurationPicker,
                            onStartTimeTap: viewModel.presentStartTimePicker,
                            onEndTimeTap: viewModel.presentEndTimePicker,
                            onAppsBlockedTap: viewModel.presentAppBlockerSheet
                        )
                        
                        FocusPresetGridView(
                            presets: viewModel.presets,
                            selectedPreset: $viewModel.state.scheduleConfiguration.selectedPreset
                        )
                    }
                    .padding(.vertical)
                    .padding(.bottom, FocusSessionView.Constants.Layout.floatingButtonBottomPadding + 60)
                }
            }
            .containerRelativeFrame([.horizontal])
            .gradientBackground()
            .navigationTitle(Constants.Strings.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(Constants.Strings.navigationTitle)
                        .foregroundStyle(.white)
                        .bold()
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button(Constants.Strings.startButtonTitle, systemImage: Constants.Symbols.startButtonIcon) {
                    viewModel.startTapped()
                }
                .buttonStyle(FTPrimaryButtonStyle())
                .padding(.horizontal, Constants.Layout.floatingButtonHorizontalPadding)
                .padding(.bottom, Constants.Layout.floatingButtonBottomPadding)
                .disabled(!viewModel.isStartButtonEnabled)
            }
            .containerRelativeFrame([.horizontal])
            
            .sheet(isPresented: $viewModel.state.isDurationPickerPresented) {
                DurationPickerSheetView(
                    hours: $viewModel.state.scheduleConfiguration.selectedHours,
                    minutes: $viewModel.state.scheduleConfiguration.selectedMinutes
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            .sheet(isPresented: $viewModel.state.isStartTimePickerPresented) {
                TimePickerSheetView(
                    selectedDate: $viewModel.state.scheduleConfiguration.startTime,
                    title: Constants.TimePicker.Strings.startTimeTitle,
                    subtitle: Constants.TimePicker.Strings.startTimeSubtitle
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            .sheet(isPresented: $viewModel.state.isEndTimePickerPresented) {
                TimePickerSheetView(
                    selectedDate: $viewModel.state.scheduleConfiguration.endTime,
                    title: Constants.TimePicker.Strings.endTimeTitle,
                    subtitle: Constants.TimePicker.Strings.endTimeSubtitle
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            .sheet(isPresented: $viewModel.state.isAppBlockerSheetPresented) {
#warning("Change ContentView with actual view")
                ContentView()
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
        }
        .preferredColorScheme(.dark)
    }
}


// MARK: - Preview
#Preview {
    FocusSessionView()
}

