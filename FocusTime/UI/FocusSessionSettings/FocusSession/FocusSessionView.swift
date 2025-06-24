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
                            SessionConfigurationView(
                                listName: viewModel.state.listName,
                                selectedIconName: viewModel.selectedPresetIconName,
                                scheduleForLater: viewModel.state.scheduleForLater,
                                formattedDuration: viewModel.formattedDuration,
                                scheduledDays: viewModel.state.scheduledDays, 
                                formattedScheduledDays: viewModel.formattedScheduledDays,
                                formattedStartTime: viewModel.formattedStartTime,
                                formattedEndTime: viewModel.formattedEndTime,
                                delegate: viewModel
                            )
                            
                            FocusPresetGridView(
                                presets: viewModel.presets,
                                selectedPresetID: viewModel.state.selectedPresetID,
                                delegate: viewModel
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
                    initialHours: viewModel.state.selectedHours,
                    initialMinutes: viewModel.state.selectedMinutes,
                    delegate: viewModel
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            .sheet(isPresented: $viewModel.state.isStartTimePickerPresented) {
                TimePickerSheetView(
                    initialDate: viewModel.state.startTime,
                    title: Constants.TimePicker.Strings.startTimeTitle,
                    subtitle: Constants.TimePicker.Strings.startTimeSubtitle,
                    pickerType: .start,
                    delegate: viewModel
                )
                .presentationDetents([.height(Constants.Layout.sheetHeight)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(Constants.Layout.sheetCornerRadius)
            }
            .sheet(isPresented: $viewModel.state.isEndTimePickerPresented) {
                TimePickerSheetView(
                    initialDate: viewModel.state.endTime,
                    title: Constants.TimePicker.Strings.endTimeTitle,
                    subtitle: Constants.TimePicker.Strings.endTimeSubtitle,
                    pickerType: .end,
                    delegate: viewModel
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

