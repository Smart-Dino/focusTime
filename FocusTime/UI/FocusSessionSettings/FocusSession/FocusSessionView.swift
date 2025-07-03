//
//  FocusSessionView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI
import FocusTimeUI

struct FocusSessionView: View {
    
    // MARK: - Fixed: ViewModel initialized in init for mocking
    @State private var viewModel: FocusSessionViewModel
    
    // MARK: - Initializer for ViewModel injection
    init(viewModel: FocusSessionViewModel = FocusSessionViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                // MARK: - Fixed: Gradient background applied to ZStack
                // Removed .containerRelativeFrame([.horizontal]) as it's often redundant with ZStack/ScrollView
                // Removed .toolbarBackground(.hidden) to allow system blur
                
                ScrollView {
                    VStack(spacing: Constants.Layout.mainVStackSpacing) {
                        // MARK: - Refactored: Pass a single binding to ScheduleConfigurationView
                        ScheduleConfigurationView( // Renamed
                            configuration: $viewModel.state.scheduleConfiguration, // New binding
                            onDurationTap: viewModel.presentDurationPicker,
                            onStartTimeTap: viewModel.presentStartTimePicker,
                            onEndTimeTap: viewModel.presentEndTimePicker,
                            onAppsBlockedTap: viewModel.presentAppBlockerSheet
                        )
                        
                        // MARK: - Refactored: Pass binding to selectedPreset
                        FocusPresetGridView(
                            presets: viewModel.presets,
                            selectedPreset: $viewModel.state.scheduleConfiguration.selectedPreset // Pass binding here
                        )
                    }
                    .padding(.vertical)
                    // Add padding to the bottom of the scroll view to make space for the floating button
                    .padding(.bottom, FocusSessionView.Constants.Layout.floatingButtonBottomPadding + 60) // Adjust 60 for button height
                }
                
            }
            .containerRelativeFrame([.horizontal])
            .gradientBackground() // Apply background here
            .navigationTitle(Constants.Strings.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            // MARK: - Fixed: Removed redundant ToolbarItem for title
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(Constants.Strings.navigationTitle)
                        .foregroundStyle(.white) // Use foregroundStyle
                        .bold()
                }
            }  
            
            // MARK: - Fixed: Floating Button using safeAreaInset
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
                    hours: $viewModel.state.scheduleConfiguration.selectedHours, // Pass binding directly
                    minutes: $viewModel.state.scheduleConfiguration.selectedMinutes // Pass binding directly
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                // MARK: - Fixed: Removed .presentationDragIndicator(.hidden)
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            .sheet(isPresented: $viewModel.state.isStartTimePickerPresented) {
                TimePickerSheetView(
                    selectedDate: $viewModel.state.scheduleConfiguration.startTime, // Pass binding directly
                    title: Constants.TimePicker.Strings.startTimeTitle,
                    subtitle: Constants.TimePicker.Strings.startTimeSubtitle,
                    pickerType: .start
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                // MARK: - Fixed: Removed .presentationDragIndicator(.hidden)
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            .sheet(isPresented: $viewModel.state.isEndTimePickerPresented) {
                TimePickerSheetView(
                    selectedDate: $viewModel.state.scheduleConfiguration.endTime, // Pass binding directly
                    title: Constants.TimePicker.Strings.endTimeTitle,
                    subtitle: Constants.TimePicker.Strings.endTimeSubtitle,
                    pickerType: .end
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                // MARK: - Fixed: Removed .presentationDragIndicator(.hidden)
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            .sheet(isPresented: $viewModel.state.isAppBlockerSheetPresented) {
                #warning("Change ContentView with actual view")
                ContentView()
                    .presentationDetents([.medium, .large])
                    // MARK: - Fixed: Removed .presentationDragIndicator(.visible) (default is visible)
                    .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            
        }
        
        // MARK: - Fixed: Removed .preferredColorScheme(.dark)
        // If the app is always dark, set this at the App level in FocusTimeApp.swift
    }
}



// MARK: - Preview
#Preview {
    FocusSessionView()
}

