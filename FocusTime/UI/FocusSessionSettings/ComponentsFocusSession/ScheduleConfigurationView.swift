//
//  ScheduleConfigurationView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//


import SwiftUI
import FocusTimeUI 

struct ScheduleConfigurationView: View {
    @Binding var configuration: ScheduleConfiguration
    
    let onDurationTap: () -> Void
    let onStartTimeTap: () -> Void
    let onEndTimeTap: () -> Void
    let onAppsBlockedTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: FocusSessionView.Constants.Configuration.Layout.mainSpacing) {
            HStack(spacing: FocusSessionView.Constants.Configuration.Layout.listIconSpacing) {
                HStack {
                    Text(FocusSessionView.Constants.Configuration.Strings.listName)
                    Spacer()
                    TextField(FocusSessionView.Constants.Configuration.Strings.listNamePlaceholder, text: $configuration.listName)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.white)
                }
                .rowStyle()
                
                Group {
                    if let selectedPreset = configuration.selectedPreset {
                        Text(selectedPreset.iconName)
                            .font(.title)
                    } else {
                        EmptyView()
                    }
                }
                .frame(width: FocusSessionView.Constants.Row.height, height: FocusSessionView.Constants.Row.height)
                .background(Color.ftRowBackground)
                .cornerRadius(FocusSessionView.Constants.Row.cornerRadius)
            }
            
            VStack(alignment: .leading, spacing: FocusSessionView.Constants.Configuration.Layout.scheduleSectionSpacing) {
                HStack {
                    Text(FocusSessionView.Constants.Configuration.Strings.scheduleForLater)
                    Spacer()
                    Toggle(FocusSessionView.Constants.Configuration.Strings.scheduleForLater, isOn: $configuration.scheduleForLater)
                        .labelsHidden()
                        .tint(FocusSessionView.Constants.Configuration.Colors.toggleTint)
                }
                .rowStyle()
                
                Text(FocusSessionView.Constants.Configuration.Strings.scheduleInfo)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, FocusSessionView.Constants.Configuration.Layout.scheduleInfoHorizontalPadding)
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
                        Text(formattedScheduledDays)
                            .foregroundStyle(.white)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
                
                Button {
                    onStartTimeTap()
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
                    onEndTimeTap()
                } label: {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.letEndTime)
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
                    onDurationTap()
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
                onAppsBlockedTap()
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
            return String(localized: "0m", comment: "Zero minutes duration")
        }
        
        return formatter.string(from: TimeInterval(configuration.selectedHours * 3600 + configuration.selectedMinutes * 60)) ?? String(localized: "0m", comment: "Fallback zero minutes duration")
    }
    
    private var formattedScheduledDays: String {
        if configuration.scheduledDays.isEmpty {
            return String(localized: "Never", comment: "No scheduled days")
        }
        if configuration.scheduledDays.count == Weekday.allCases.count {
            return String(localized: "Every Day", comment: "Scheduled for every day")
        }
        if configuration.scheduledDays == Set([.saturday, .sunday]) {
            return String(localized: "Weekends", comment: "Scheduled for weekends")
        }
        if configuration.scheduledDays == Set([.monday, .tuesday, .wednesday, .thursday, .friday]) {
            return String(localized: "Weekdays", comment: "Scheduled for weekdays")
        }
        
        let sortedDays = configuration.scheduledDays.sorted()
        if sortedDays.count <= 3 {
            return sortedDays.map { $0.shortName }.joined(separator: String(localized: ", ", comment: "Separator for list of days"))
        } else {
            return String(localized: "\(sortedDays.count) days", comment: "Number of days scheduled")
        }
    }
    
    private let twentyFourHourTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter
    }()
    
    private var formattedStartTime: String {
        twentyFourHourTimeFormatter.string(from: configuration.startTime)
    }
    
    private var formattedEndTime: String {
        twentyFourHourTimeFormatter.string(from: configuration.endTime)
    }
}
