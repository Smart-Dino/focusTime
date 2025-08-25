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
                Group {
                HStack {
                    Text(FocusSessionView.Constants.Configuration.Strings.listName)
                    Spacer()
                    TextField(
                        FocusSessionView.Constants.Configuration.Strings.listNamePlaceholder,
                        text: .binding(
                            get: viewModel.state.blockItem.name,
                            set: viewModel.setListName(listName:)
                        )
                    )
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(.white)
                }
                
                    TextField(String(), text: .binding(
                        get: viewModel.state.blockItem.emoji,
                        set: viewModel.setCustomPresetEmoji(emoji:)
                    ))
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .aspectRatio(1, contentMode: .fit)
                    .submitLabel(.done)
                    .onChange(of: viewModel.state.blockItem.emoji) {
                        // Getting value straight from the viewModel is safer
                        // than using newValue if there is a vast amount of input happening.
                        
                        // No, filtering inside the setter method does not work.
                        // We need to react to change with onChange and only then replace string to
                        // the emoji.
                        viewModel.setCustomPresetEmoji(
                            emoji: viewModel.state.blockItem.emoji.filterToFirstEmoji()
                        )
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
                            get: viewModel.state.isScheduledForLater,
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
            
            if viewModel.state.isScheduledForLater {
                Menu {
                    ForEach(Weekday.allCases) { day in
                        Toggle(day.description, isOn: .binding(
                            get: viewModel.state.blockItem.days.contains(day),
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
                
                if !viewModel.state.blockItem.days.isEmpty {
                    Text(viewModel.state.blockItem.days.description)
                        .font(.caption)
                }
                
                Button {
                    viewModel.presentStartTimePicker()
                } label: {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.startTime)
                        Spacer()
                        Text(viewModel.state.blockItem.type.structuredDescription.startTime ?? String())
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
                        Text(viewModel.state.blockItem.type.structuredDescription.endTime ?? String())
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
                        Text(viewModel.state.blockItem.type.structuredDescription.duration ?? String())
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
        .onChange(of: viewModel.state) {
            viewModel.refreshBlockItem()
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
                        get: viewModel.state.durationHours,
                        set: viewModel.setHours(hours:)
                    ),
                    minutes: .binding(
                        get: viewModel.state.durationMinutes,
                        set: viewModel.setMinutes(minutes:)
                    )
                )
                .presentationDetents([.height(FocusSessionView.Constants.Layout.sheetHeight)])
                
            case .startTimePicker:
                TimePickerSheetView(
                    selectedDate: .binding(
                        get: viewModel.state.startTime,
                        set: viewModel.setStartTime(startTime:)
                    ),
                    title: TimePickerConstants.Strings.startTimeTitle,
                    subtitle: TimePickerConstants.Strings.startTimeSubtitle
                )
                .presentationDetents([.height(FocusSessionView.Constants.Layout.sheetHeight)])
                
            case .endTimePicker:
                TimePickerSheetView(
                    selectedDate: .binding(
                        get: viewModel.state.endTime,
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
