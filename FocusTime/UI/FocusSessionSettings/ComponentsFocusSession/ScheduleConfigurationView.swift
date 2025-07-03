//
//  ScheduleConfigurationView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//


import SwiftUI

// MARK: - ScheduleConfigurationView (Renamed from SessionConfigurationView)
struct ScheduleConfigurationView: View { // Renamed struct
    // MARK: - Refactored: Encapsulated properties into a single binding
    @Binding var configuration: ScheduleConfiguration // Changed type
    
    // MARK: - Refactored: Closures for actions instead of delegate
    let onDurationTap: () -> Void
    let onStartTimeTap: () -> Void
    let onEndTimeTap: () -> Void
    let onAppsBlockedTap: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: FocusSessionView.Constants.Configuration.Layout.mainSpacing) {
            HStack(spacing: FocusSessionView.Constants.Configuration.Layout.listIconSpacing) {
                HStack {
                    Text(FocusSessionView.Constants.Configuration.Strings.listName)
                    Spacer()
                    TextField(FocusSessionView.Constants.Configuration.Strings.listNamePlaceholder, text: $configuration.listName)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.white) // Use foregroundStyle
                }
                .rowStyle()
                
                Group {
                    if let selectedPreset = configuration.selectedPreset { // Changed to use FocusPreset enum
                        Text(selectedPreset.iconName) // Assumed iconName is an emoji String
                            .font(.title)
                    } else {
                        EmptyView()
                    }
                }
                .frame(width: FocusSessionView.Constants.Row.height, height: FocusSessionView.Constants.Row.height)
                .background(FocusSessionView.Constants.Row.background)
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
                    .foregroundStyle(.gray) // Use foregroundStyle
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, FocusSessionView.Constants.Configuration.Layout.scheduleInfoHorizontalPadding)
            }
            
            if configuration.scheduleForLater {
                Menu {
                    ForEach(Weekday.allCases.sorted()) { day in
                        Toggle(day.rawValue.capitalized, isOn: Binding(
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
                            .foregroundStyle(.white) // Use foregroundStyle
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor) // Use foregroundStyle
                    }
                }
                .rowStyle()
                
                Button(action: onStartTimeTap) {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.startTime)
                        Spacer()
                        Text(formattedStartTime)
                            .foregroundStyle(.white) // Use foregroundStyle
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor) // Use foregroundStyle
                    }
                }
                .rowStyle()
                
                Button(action: onEndTimeTap) {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.letEndTime) // Corrected constant name
                        Spacer()
                        Text(formattedEndTime)
                            .foregroundStyle(.white) // Use foregroundStyle
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor) // Use foregroundStyle
                    }
                }
                .rowStyle()
            } else {
                Button(action: onDurationTap) {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.duration)
                        Spacer()
                        Text(formattedDuration)
                            .foregroundStyle(.white) // Use foregroundStyle
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor) // Use foregroundStyle
                    }
                }
                .rowStyle()
            }
            
            Button(action: onAppsBlockedTap) {
                HStack {
                    Text(FocusSessionView.Constants.Configuration.Strings.appsBlocked)
                    Spacer()
                    Text(FocusSessionView.Constants.Configuration.Strings.appsBlockedList)
                    Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                        .foregroundStyle(FocusSessionView.Constants.Colors.chevronColor) // Use foregroundStyle
                }
            }
            .rowStyle()
        }
        .padding(.horizontal)
    }
    
    private var formattedDuration: String {
        let h = FocusSessionView.Constants.Time.hourSuffix
        let m = FocusSessionView.Constants.Time.minuteSuffix
        if configuration.selectedHours > 0 {
            return "\(configuration.selectedHours)\(h) \(configuration.selectedMinutes)\(m)"
        } else {
            return "\(configuration.selectedMinutes)\(m)"
        }
    }
    
    // MARK: - Updated formattedScheduledDays logic
    private var formattedScheduledDays: String {
        if configuration.scheduledDays.isEmpty {
            return "Never"
        }
        if configuration.scheduledDays.count == Weekday.allCases.count {
            return "Every Day"
        }
        if configuration.scheduledDays == Set([.saturday, .sunday]) {
            return "Weekends"
        }
        if configuration.scheduledDays == Set([.monday, .tuesday, .wednesday, .thursday, .friday]) {
            return "Weekdays"
        }
        
        // If specific days are selected, show a count or list if few
        let sortedDays = configuration.scheduledDays.sorted()
        if sortedDays.count <= 3 { // Arbitrary threshold, adjust as needed
            return sortedDays.map { $0.shortName }.joined(separator: ", ")
        } else {
            return "\(sortedDays.count) days"
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
