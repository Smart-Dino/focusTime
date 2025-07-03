//
//  SessionConfigurationView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//


import SwiftUI

// fileprivate struct FramePreferenceKey: PreferenceKey { // No longer needed with native Menu
//     static let defaultValue: CGRect = .zero
//     static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
//         value = nextValue()
//     }
// }

struct SessionConfigurationView: View {
    // MARK: - Properties
    let listName: String
    let selectedIconName: String?
    let scheduleForLater: Bool
    let formattedDuration: String
    @Binding var scheduledDays: Set<Weekday> // Changed to Binding from let
    let formattedScheduledDays: String
    let formattedStartTime: String
    let formattedEndTime: String
    
    weak var delegate: SessionConfigurationViewDelegate?
    
    // @State private var showDaysPicker = false // No longer needed with native Menu
    // @State private var dayPickerButtonFrame: CGRect = .zero // No longer needed with native Menu
            
    // MARK: - Body
    var body: some View {
        let listNameBinding = Binding<String>(
            get: { self.listName },
            set: { newName in self.delegate?.sessionConfigurationDidUpdateListName(to: newName) }
        )
        
        let scheduleForLaterBinding = Binding<Bool>(
            get: { self.scheduleForLater },
            set: { newValue in
                self.delegate?.sessionConfigurationDidUpdateScheduleToggle(to: newValue)
                // if showDaysPicker { // No longer needed with native Menu
                //     withAnimation { showDaysPicker = false }
                // }
            }
        )
        
        // ZStack(alignment: .topLeading) { // No longer needed for DaysPickerPopup
        //     if showDaysPicker {
        //         FocusSessionView.Constants.Configuration.Colors.tapCatchingBackground
        //             .onTapGesture {
        //                 withAnimation { showDaysPicker = false }
        //             }
        //             .ignoresSafeArea()
        //             .zIndex(FocusSessionView.Constants.Configuration.ZIndex.backgroundDim)
        //     }
            
            VStack(alignment: .leading, spacing: FocusSessionView.Constants.Configuration.Layout.mainSpacing) {
                if let iconName = selectedIconName {
                    HStack(spacing: FocusSessionView.Constants.Configuration.Layout.listIconSpacing) {
                        HStack {
                            Text(FocusSessionView.Constants.Configuration.Strings.listName)
                            Spacer()
                            TextField(FocusSessionView.Constants.Configuration.Strings.listNamePlaceholder, text: listNameBinding)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.white)
                        }
                        .rowStyle()
                        
                        ZStack {
                            FocusSessionView.Constants.Row.background
                            Image(iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: FocusSessionView.Constants.Configuration.Layout.selectedIconSize, height: FocusSessionView.Constants.Configuration.Layout.selectedIconSize)
                        }
                        .frame(width: FocusSessionView.Constants.Row.height, height: FocusSessionView.Constants.Row.height)
                        .cornerRadius(FocusSessionView.Constants.Row.cornerRadius)
                    }
                } else {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.listName)
                        Spacer()
                        TextField(FocusSessionView.Constants.Configuration.Strings.listNamePlaceholder, text: listNameBinding)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.white)
                    }
                    .rowStyle()
                }
                
                VStack(alignment: .leading, spacing: FocusSessionView.Constants.Configuration.Layout.scheduleSectionSpacing) {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.scheduleForLater)
                        Spacer()
                        Toggle("", isOn: scheduleForLaterBinding)
                            .tint(FocusSessionView.Constants.Configuration.Colors.toggleTint) // #warning fixed by keeping tint for desired color
                    }
                    .rowStyle()
                    
                    Text(FocusSessionView.Constants.Configuration.Strings.scheduleInfo)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, FocusSessionView.Constants.Configuration.Layout.scheduleInfoHorizontalPadding)
                }
                
                if scheduleForLater {
                    // Comment addressed: Replaced custom popup with native Menu
                    Menu {
                        ForEach(Weekday.allCases.sorted()) { day in
                            Toggle(day.rawValue.capitalized, isOn: Binding(
                                get: { self.scheduledDays.contains(day) },
                                set: { isSelected in
                                    if isSelected {
                                        self.scheduledDays.insert(day)
                                    } else {
                                        self.scheduledDays.remove(day)
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
                                .foregroundColor(FocusSessionView.Constants.Colors.chevronColor) // Comment addressed: Moved color to constants
                        }
                    }
                    .rowStyle()
                    // .background(...) and .zIndex(...) for custom popup removed
                    // .onPreferenceChange(...) also removed
                    
                    Button {
                        delegate?.sessionConfigurationDidTapStartTime()
                    } label: {
                        HStack {
                            Text(FocusSessionView.Constants.Configuration.Strings.startTime)
                            Spacer()
                            Text(formattedStartTime)
                                .foregroundColor(.white)
                            Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                                .foregroundColor(FocusSessionView.Constants.Colors.chevronColor) // Comment addressed: Moved color to constants
                        }
                    }
                    .rowStyle()
                    
                    Button(action: { delegate?.sessionConfigurationDidTapEndTime() }) {
                        HStack {
                            Text(FocusSessionView.Constants.Configuration.Strings.endTime)
                            Spacer()
                            Text(formattedEndTime)
                                .foregroundColor(.white)
                            Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                                .foregroundColor(FocusSessionView.Constants.Colors.chevronColor) // Comment addressed: Moved color to constants
                        }
                    }
                    .rowStyle()
                } else {
                    Button(action: { delegate?.sessionConfigurationDidTapDuration() }) {
                        HStack {
                            Text(FocusSessionView.Constants.Configuration.Strings.duration)
                            Spacer()
                            Text(formattedDuration)
                                .foregroundColor(.white)
                            Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                                .foregroundColor(FocusSessionView.Constants.Colors.chevronColor) // Comment addressed: Moved color to constants
                        }
                    }
                    .rowStyle()
                }
                
                Button(action: { delegate?.sessionConfigurationDidTapAppsBlocked() }) {
                    HStack {
                        Text(FocusSessionView.Constants.Configuration.Strings.appsBlocked)
                        Spacer()
                        Text(FocusSessionView.Constants.Configuration.Strings.appsBlockedList)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                            .foregroundColor(FocusSessionView.Constants.Colors.chevronColor) // Comment addressed: Moved color to constants
                    }
                }
                .rowStyle()
            }
            .padding(.horizontal)
            // .coordinateSpace(name: "zstack_container") // No longer needed without custom popup positioning
        // } // Closing the ZStack, if it was intended to wrap the whole content
    }
}
