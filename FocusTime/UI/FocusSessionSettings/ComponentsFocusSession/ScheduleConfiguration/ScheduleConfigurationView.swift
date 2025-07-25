//
//  ScheduleConfigurationView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//


import SwiftUI
import FocusTimeUI

struct ScheduleConfigurationView: View {
    struct Actions {
        let onDurationTap: () -> Void
        let onStartTimeTap: () -> Void
        let onEndTimeTap: () -> Void
        let onAppsBlockedTap: () -> Void
        let onScheduledDaysTap: () -> Void
        let onEmojiTapped: (_ focusedState: FocusState<Bool>.Binding) -> Void
        
    }
    
    // MARK: - Properties
    @Binding var configuration: ScheduleConfiguration
    let actions: Actions
    @FocusState var isEmojiTextFieldFocused: Bool
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: FocusSessionView.Constants.Configuration.Layout.mainSpacing) {
            HStack(spacing: FocusSessionView.Constants.Configuration.Layout.listIconSpacing) {
                HStack {
                    Text(FocusSessionView.Constants.Configuration.Strings.listName)
                    Spacer()
                    TextField(
                        FocusSessionView.Constants.Configuration.Strings.listNamePlaceholder,
                        text: $configuration.listName
                    )
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(.white)
                }
                .rowStyle()
                
                Group {
                    if let selectedPreset = configuration.selectedPreset {
                        Text(selectedPreset.iconName)
                            .font(.title)
                            .onTapGesture {
                                actions.onEmojiTapped($isEmojiTextFieldFocused)
                            }
                    } else {
                        TextField("", text: Binding(
                            get: { configuration.customPresetEmoji },
                            set: { newValue in
                                configuration.customPresetEmoji = String(newValue.prefix(1))
                            }
                        ))
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .focused($isEmojiTextFieldFocused)
                        .submitLabel(.done)
                        .onAppear {
                            if configuration.customPresetEmoji.isEmpty {
                                isEmojiTextFieldFocused = true
                            }
                        }
                    }
                }
                .frame(width: FocusSessionView.Constants.Row.height, height: FocusSessionView.Constants.Row.height)
                .background(Color.ftPresetBackgroundColor)
                .cornerRadius(FocusSessionView.Constants.Row.cornerRadius)
            }
            
            VStack(alignment: .leading, spacing: FocusSessionView.Constants.Configuration.Layout.scheduleSectionSpacing) {
                HStack {
                    Text(FocusSessionView.Constants.Configuration.Strings.scheduleForLater)
                    Spacer()
                    Toggle(
                        FocusSessionView.Constants.Configuration.Strings.scheduleForLater,
                        isOn: $configuration.scheduleForLater
                    )
                    .labelsHidden()
                    .tint(FocusSessionView.Constants.Configuration.Colors.toggleTint)
                }
                .rowStyle()
                
                Text(FocusSessionView.Constants.Configuration.Strings.scheduleInfo)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
            }
            
            if configuration.scheduleForLater {
                Menu {
                    ForEach(Weekday.allCases.sorted()) { day in
                        Toggle(LocalizedStringKey(day.rawValue.capitalized), isOn: Binding(
                            get: { self.configuration.scheduledDays.contains(day) },
                            set: { isSelected in
                                if isSelected {
                                    self.configuration.scheduledDays.insert(day)
                                } else {
                                    self.configuration.scheduledDays.remove(day)
                                }
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
                
                if !configuration.scheduledDays.isEmpty {
                    Text(formattedFullScheduledDays)
                        .font(.caption)
                }
       
                Button {
                    actions.onStartTimeTap()
                } label: {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.startTime)
                        Spacer()
                        Text(formattedStartTime)
                            .foregroundStyle(.white)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
                
                Button {
                    actions.onEndTimeTap()
                } label: {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.endTime)
                        Spacer()
                        Text(formattedEndTime)
                            .foregroundStyle(.white)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
            } else {
                Button {
                    actions.onDurationTap()
                } label: {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.duration)
                        Spacer()
                        Text(formattedDuration)
                            .foregroundStyle(.white)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
            }
            
            Button {
                actions.onAppsBlockedTap()
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
    }
    
    private var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .dropAll
        
        if configuration.selectedHours == 0 && configuration.selectedMinutes == 0 {
            return String(localized: "0m", table: "SessionLocalizable", comment: "Zero minutes duration")
        }
        
        return formatter.string(from: TimeInterval(configuration.selectedHours * 3600 + configuration.selectedMinutes * 60)) ?? String(localized: "0m", table: "SessionLocalizable", comment: "Fallback zero minutes duration")
    }
    
    private var formattedFullScheduledDays: String {
        if configuration.scheduledDays.count == Weekday.allCases.count {
            return String(localized: "Every Day", table: "SessionLocalizable", comment: "Scheduled for every day")
        }
        if configuration.scheduledDays == Set([.saturday, .sunday]) {
            return String(localized: "Weekends", table: "SessionLocalizable", comment: "Scheduled for weekends")
        }
        if configuration.scheduledDays == Set([.monday, .tuesday, .wednesday, .thursday, .friday]) {
            return String(localized: "Weekdays", table: "SessionLocalizable", comment: "Scheduled for weekdays")
        }
        
        let sortedDays = configuration.scheduledDays.sorted()
        return sortedDays.map { $0.fullName }.joined(separator: ", ")
    }
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var formattedStartTime: String {
        timeFormatter.string(from: configuration.startTime)
    }
    
    private var formattedEndTime: String {
        timeFormatter.string(from: configuration.endTime)
    }
}
