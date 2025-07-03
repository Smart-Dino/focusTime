//
//  FocusSessionView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI
import FocusTimeUI

struct FocusSessionView: View {
    
    @State private var viewModel = FocusSessionViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                VStack {
                    ScrollView {
                        VStack(spacing: Constants.Layout.mainVStackSpacing) {
                            // MARK: - Refactored: Pass a single binding to SessionConfigurationView
                            SessionConfigurationView(
                                configuration: $viewModel.state.sessionConfiguration, // New binding
                                onDurationTap: viewModel.presentDurationPicker,
                                onStartTimeTap: viewModel.presentStartTimePicker,
                                onEndTimeTap: viewModel.presentEndTimePicker,
                                onAppsBlockedTap: viewModel.presentAppBlockerSheet
                            )
                            
                            // MARK: - Refactored: Pass binding to selectedPresetID
                            FocusPresetGridView(
                                presets: viewModel.presets,
                                selectedPresetID: $viewModel.state.sessionConfiguration.selectedPresetID // Pass binding here
                            )
                        }
                        .padding(.vertical)
                    }
                    
                    Button(Constants.Strings.startButtonTitle, systemImage: Constants.Symbols.startButtonIcon) {
                        viewModel.startTapped()
                    }
                    .buttonStyle(FTPrimaryButtonStyle())
                    .padding([.horizontal, .bottom])
                    .disabled(!viewModel.isStartButtonEnabled)
                }
                
            }
            .containerRelativeFrame([.horizontal])
            .gradientBackground()
            .navigationTitle(Constants.Strings.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(Constants.Strings.navigationTitle).foregroundColor(.white).bold()
                }
            }
            .toolbarBackground(.hidden)
            .sheet(isPresented: $viewModel.state.isDurationPickerPresented) {
                DurationPickerSheetView(
                    hours: $viewModel.state.sessionConfiguration.selectedHours, // Pass binding directly
                    minutes: $viewModel.state.sessionConfiguration.selectedMinutes // Pass binding directly
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            .sheet(isPresented: $viewModel.state.isStartTimePickerPresented) {
                TimePickerSheetView(
                    selectedDate: $viewModel.state.sessionConfiguration.startTime, // Pass binding directly
                    title: Constants.TimePicker.Strings.startTimeTitle,
                    subtitle: Constants.TimePicker.Strings.startTimeSubtitle,
                    pickerType: .start
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            .sheet(isPresented: $viewModel.state.isEndTimePickerPresented) {
                TimePickerSheetView(
                    selectedDate: $viewModel.state.sessionConfiguration.endTime, // Pass binding directly
                    title: Constants.TimePicker.Strings.endTimeTitle,
                    subtitle: Constants.TimePicker.Strings.endTimeSubtitle,
                    pickerType: .end
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            .sheet(isPresented: $viewModel.state.isAppBlockerSheetPresented) {
                #warning("Change ContentView with actual view")
                ContentView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
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

