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
    @FocusState var isFocusedEmojiField
    @State var viewModel: ScheduleConfigurationViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Layout.mainSpacing) {
            HStack(spacing: Constants.Layout.listIconSpacing) {
                Group {
                HStack {
                    Text(Constants.Strings.listName)
                    Spacer()
                    TextField(
                        Constants.Strings.listNamePlaceholder,
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
                    .focused($isFocusedEmojiField)
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
                    .simultaneousGesture(TapGesture().onEnded {
                        viewModel.clearEmoji()
                    })
                    .onChange(of: isFocusedEmojiField) {
                        viewModel.updateDelegateEmojiFocusStateStatus(with: isFocusedEmojiField)
                    }
                }
                .rowStyle()
            }
            
            VStack(alignment: .leading, spacing: Constants.Layout.scheduleSectionSpacing) {
                HStack {
                    Text(Constants.Strings.scheduleForLater)
                    Spacer()
                    Toggle(
                        Constants.Strings.scheduleForLater,
                        isOn: .binding(
                            get: viewModel.state.isScheduledForLater,
                            set: viewModel.setScheduleForLater(isOn:)
                        )
                    )
                    .labelsHidden()
                    .tint(Constants.Colors.toggleTint)
                }
                .rowStyle()
                
                Text(Constants.Strings.scheduleInfo)
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
                        Text(Constants.Strings.scheduledDays)
                        Spacer()
                        Image(systemName: Constants.Symbols.navigationChevron)
                            .foregroundStyle(Constants.Colors.chevronColor)
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
                        Text(Constants.Strings.startTimeTitle)
                        Spacer()
                        Text(viewModel.state.blockItem.type.structuredDescription.startTime ?? String())
                            .foregroundStyle(.white)
                        Image(systemName: Constants.Symbols.navigationChevron)
                            .foregroundStyle(Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
                
                Button {
                    viewModel.presentEndTimePicker()
                } label: {
                    HStack {
                        Text(Constants.Strings.endTimeTitle)
                        Spacer()
                        Text(viewModel.state.blockItem.type.structuredDescription.endTime ?? String())
                            .foregroundStyle(.white)
                        Image(systemName: Constants.Symbols.navigationChevron)
                            .foregroundStyle(Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
            } else {
                Button {
                    viewModel.presentDurationPicker()
                } label: {
                    HStack {
                        Text(Constants.Strings.duration)
                        Spacer()
                        Text(viewModel.state.blockItem.type.structuredDescription.duration ?? String())
                            .foregroundStyle(.white)
                        Image(systemName: Constants.Symbols.navigationChevron)
                            .foregroundStyle(Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
            }
            
            Button {
                viewModel.presentAppBlockerSheet()
            } label: {
                HStack {
                    Text(Constants.Strings.appsBlocked)
                    Spacer()
                    Text(Constants.Strings.appsBlockedList)
                    Image(systemName: Constants.Symbols.navigationChevron)
                        .foregroundStyle(Constants.Colors.chevronColor)
                }
            }
            .rowStyle()
        }
        .padding(.horizontal)
//        .onChange(of: viewModel.state) {
//            viewModel.refreshBlockItem()
//        }
        
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
                    ),
                    title: Constants.Strings.durationPickerTitle,
                    subtitle: Constants.Strings.durationPickerSubtitle
                )
                .presentationDetents([.height(FocusSessionView.Constants.Layout.sheetHeight)])
                
            case .startTimePicker:
                TimePickerSheetView(
                    selectedDate: .binding(
                        get: viewModel.state.startTime,
                        set: viewModel.setStartTime(startTime:)
                    ),
                    title: Constants.Strings.startTimeTitle,
                    subtitle: Constants.Strings.startTimeSubtitle,
                    minuteInterval: Constants.DefaultValues.minuteInterval
                )
                .presentationDetents([.height(FocusSessionView.Constants.Layout.sheetHeight)])
                
            case .endTimePicker:
                TimePickerSheetView(
                    selectedDate: .binding(
                        get: viewModel.state.endTime,
                        set: viewModel.setEndTime(endTime:)
                    ),
                    title: Constants.Strings.endTimeTitle,
                    subtitle: Constants.Strings.endTimeSubtitle,
                    minuteInterval: Constants.DefaultValues.minuteInterval
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
