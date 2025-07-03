//
//  SessionConfigurationView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//


import SwiftUI

// MARK: - New: SessionConfiguration struct (can be in its own file like FocusModels.swift)
// This struct defines the data that SessionConfigurationView configures.
struct SessionConfiguration {
    var listName: String
    var scheduleForLater: Bool
    var scheduledDays: Set<Weekday>
    var startTime: Date
    var endTime: Date
    var selectedPresetID: UUID?
    // MARK: - Fixed: Added selectedHours and selectedMinutes to SessionConfiguration
    var selectedHours: Int
    var selectedMinutes: Int
}

struct SessionConfigurationView: View {
    // MARK: - Refactored: Encapsulated properties into a single binding
    @Binding var configuration: SessionConfiguration
    
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
                        .foregroundColor(.white)
                }
                .rowStyle()
                
                Group {
                    if let selectedPresetID = configuration.selectedPresetID,
                       let preset = FocusSessionView.Constants.Data.presets.first(where: { $0.id == selectedPresetID }) {
                        Text(preset.iconName) // Assumed iconName is an emoji String
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
                    .foregroundColor(.gray)
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
                            .foregroundColor(.white)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundColor(FocusSessionView.Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
                
                Button(action: onStartTimeTap) {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.startTime)
                        Spacer()
                        Text(formattedStartTime)
                            .foregroundColor(.white)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundColor(FocusSessionView.Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
                
                Button(action: onEndTimeTap) {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.endTime)
                        Spacer()
                        Text(formattedEndTime)
                            .foregroundColor(.white)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundColor(FocusSessionView.Constants.Colors.chevronColor)
                    }
                }
                .rowStyle()
            } else {
                Button(action: onDurationTap) {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.duration)
                        Spacer()
                        Text(formattedDuration)
                            .foregroundColor(.white)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundColor(FocusSessionView.Constants.Colors.chevronColor)
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
                        .foregroundColor(FocusSessionView.Constants.Colors.chevronColor)
                }
            }
            .rowStyle()
        }
        .padding(.horizontal)
    }
    
    // MARK: - Fixed: Now accesses properties directly from `configuration`
    private var formattedDuration: String {
        let h = FocusSessionView.Constants.Time.hourSuffix
        let m = FocusSessionView.Constants.Time.minuteSuffix
        if configuration.selectedHours > 0 {
            return "\(configuration.selectedHours)\(h) \(configuration.selectedMinutes)\(m)"
        } else {
            return "\(configuration.selectedMinutes)\(m)"
        }
    }
    
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
        
        let sortedDays = configuration.scheduledDays.sorted()
        return sortedDays.map { $0.shortName }.joined(separator: ", ")
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
