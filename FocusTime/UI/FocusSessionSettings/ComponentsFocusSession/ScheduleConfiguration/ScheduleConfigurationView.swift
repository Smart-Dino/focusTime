//
//  ScheduleConfigurationView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//


import SwiftUI
import FocusTimeUI

struct ScheduleConfigurationView: View {
    // MARK: - Properties
    @State var viewModel: ScheduleConfigurationViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: FocusSessionView.Constants.Configuration.Layout.mainSpacing) {
            HStack(spacing: FocusSessionView.Constants.Configuration.Layout.listIconSpacing) {
                HStack {
                    Text(FocusSessionView.Constants.Configuration.Strings.listName)
                    Spacer()
                    TextField(
                        FocusSessionView.Constants.Configuration.Strings.listNamePlaceholder,
                        text: .binding(
                            get: viewModel.state.scheduleConfiguration.listName,
                            set: viewModel.setListName(listName:)
                        )
                    )
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(.white)
                }
                .rowStyle()
                
                Group {
                    if let selectedPreset = viewModel.state.scheduleConfiguration.selectedPreset {
                        Text(selectedPreset.iconName)
                            .font(.title)
                            .onTapGesture {
                                viewModel.handlePresetIconTap()
                            }
                    } else {
                        TextField("", text: .binding(
                            get: viewModel.state.scheduleConfiguration.customPresetEmoji,
                            set: viewModel.setCustomPresetEmoji(emoji:)
                        ))
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .focused(viewModel.state.$isEmojiTextFieldFocused)
                        .submitLabel(.done)
                        .onAppear {
                            if viewModel.state.scheduleConfiguration.customPresetEmoji.isEmpty && !viewModel.state.isEmojiTextFieldFocused {
                                viewModel.state.isEmojiTextFieldFocused = true
                            }
                        }
                    }
                }
                .rowStyle()
            }
            
            VStack(alignment: .leading, spacing: FocusSessionView.Constants.Configuration.Layout.scheduleSectionSpacing) {
                HStack {
                    Text(FocusSessionView.Constants.Configuration.Strings.scheduleForLater)
                    Spacer()
                    Toggle(
                        FocusSessionView.Constants.Configuration.Strings.scheduleForLater,
                        isOn: .binding(
                            get: viewModel.state.scheduleConfiguration.scheduleForLater,
                            set: viewModel.setScheduleForLater(isOn:)
                        )
                    )
                    .labelsHidden()
                    .tint(FocusSessionView.Constants.Configuration.Colors.toggleTint)
                }
                .rowStyle()
                
                Text(FocusSessionView.Constants.Configuration.Strings.scheduleInfo)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
            }
            
            if viewModel.state.scheduleConfiguration.scheduleForLater {
                Menu {
                    ForEach(Weekday.allCases) { day in
                        Toggle(day.description, isOn: .binding(
                            get: viewModel.state.scheduleConfiguration.scheduledDays.contains(day),
                            set: { isSelected in
                                viewModel.setScheduledDay(day, isSelected: isSelected)
                            }
                        ))
                    }
                } label: {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.scheduledDays)
                        Spacer()
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor)
                    }
                }
                .menuActionDismissBehavior(.disabled)
                .rowStyle()
                
                if !viewModel.state.scheduleConfiguration.scheduledDays.isEmpty {
                    Text(viewModel.state.formattedFullScheduledDays)
                        .font(.caption)
                }
                
                Button {
                    viewModel.presentStartTimePicker()
                } label: {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.startTime)
                        Spacer()
                        Text(viewModel.state.formattedStartTime)
                            .foregroundStyle(.white)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
                
                Button {
                    viewModel.presentEndTimePicker()
                } label: {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.endTime)
                        Spacer()
                        Text(viewModel.state.formattedEndTime)
                            .foregroundStyle(.white)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
            } else {
                Button {
                    viewModel.presentDurationPicker()
                } label: {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.duration)
                        Spacer()
                        Text(viewModel.state.formattedDuration)
                            .foregroundStyle(.white)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
            }
            
            Button {
                viewModel.presentAppBlockerSheet()
            } label: {
                HStack {
                    Text(FocusSessionView.Constants.Configuration.Strings.appsBlocked)
                    Spacer()
                    Text(FocusSessionView.Constants.Configuration.Strings.appsBlockedList)
                    Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                        .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor)
                }
            }
            .rowStyle()
        }
        .padding(.horizontal)
        .onChange(of: viewModel.state.isEmojiTextFieldFocused) { _, newValue in
            viewModel.setEmojiTextFieldFocus(to: newValue)
        }
        
        // MARK: - Sheet Presentation
        .sheet(
            item: .binding(
                get: viewModel.state.activeSheet,
                set: viewModel.dismissSheet
            )
        ) { sheetType in
            switch sheetType {
            case .durationPicker:
                DurationPickerSheetView(
                    hours: .binding(
                        get: viewModel.state.scheduleConfiguration.selectedHours,
                        set: viewModel.setHours(hours:)
                    ),
                    minutes: .binding(
                        get: viewModel.state.scheduleConfiguration.selectedMinutes,
                        set: viewModel.setMinutes(minutes:)
                    )
                )
                .presentationDetents([.height(FocusSessionView.Constants.Layout.sheetHeight)])
                
            case .startTimePicker:
                TimePickerSheetView(
                    selectedDate: .binding(
                        get: viewModel.state.scheduleConfiguration.startTime,
                        set: viewModel.setStartTime(startTime:)
                    ),
                    title: TimePickerConstants.Strings.startTimeTitle,
                    subtitle: TimePickerConstants.Strings.startTimeSubtitle
                )
                .presentationDetents([.height(FocusSessionView.Constants.Layout.sheetHeight)])
                
            case .endTimePicker:
                TimePickerSheetView(
                    selectedDate: .binding(
                        get: viewModel.state.scheduleConfiguration.endTime,
                        set: viewModel.setEndTime(endTime:)
                    ),
                    title: TimePickerConstants.Strings.endTimeTitle,
                    subtitle: TimePickerConstants.Strings.endTimeSubtitle
                )
                .presentationDetents([.height(FocusSessionView.Constants.Layout.sheetHeight)])
                
            case .appBlockerSheet:
#warning("Change ContentView with actual view")
                Text("App Blocker List View Placeholder")
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    ScheduleConfigurationView(viewModel: ScheduleConfigurationViewModel())
        .preferredColorScheme(.dark)
}
