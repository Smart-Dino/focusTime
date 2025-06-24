//
//  SessionConfigurationView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//


import SwiftUI

fileprivate struct FramePreferenceKey: PreferenceKey {
    static let defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


struct SessionConfigurationView: View {
    let listName: String
    let selectedIconName: String?
    let scheduleForLater: Bool
    let formattedDuration: String
    let scheduledDays: Set<Weekday>
    let formattedScheduledDays: String
    let formattedStartTime: String
    let formattedEndTime: String
    
    weak var delegate: SessionConfigurationViewDelegate?
    
    @State private var showDaysPicker = false
    @State private var dayPickerButtonFrame: CGRect = .zero
    
    private typealias Strings = FocusSessionView.Constants.Configuration.Strings
    private typealias Layout = FocusSessionView.Constants.Configuration.Layout
    private typealias ConfigColors = FocusSessionView.Constants.Configuration.Colors
    private typealias ZIndex = FocusSessionView.Constants.Configuration.ZIndex
    
    var body: some View {
        let listNameBinding = Binding<String>(
            get: { self.listName },
            set: { newName in self.delegate?.sessionConfigurationDidUpdateListName(to: newName) }
        )
        
        let scheduleForLaterBinding = Binding<Bool>(
            get: { self.scheduleForLater },
            set: { newValue in
                self.delegate?.sessionConfigurationDidUpdateScheduleToggle(to: newValue)
                if showDaysPicker {
                    withAnimation { showDaysPicker = false }
                }
            }
        )
        
        ZStack(alignment: .topLeading) {
            if showDaysPicker {
                ConfigColors.tapCatchingBackground
                    .onTapGesture {
                        withAnimation { showDaysPicker = false }
                    }
                    .ignoresSafeArea()
                    .zIndex(ZIndex.backgroundDim)
            }
            
            VStack(alignment: .leading, spacing: Layout.mainSpacing) {
                if let iconName = selectedIconName {
                    HStack(spacing: Layout.listIconSpacing) {
                        HStack {
                            Text(Strings.listName)
                            Spacer()
                            TextField(Strings.listNamePlaceholder, text: listNameBinding)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.white)
                        }
                        .rowStyle()
                        
                        ZStack {
                            FocusSessionView.Constants.Row.background
                            Image(iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: Layout.selectedIconSize, height: Layout.selectedIconSize)
                        }
                        .frame(width: FocusSessionView.Constants.Row.height, height: FocusSessionView.Constants.Row.height)
                        .cornerRadius(FocusSessionView.Constants.Row.cornerRadius)
                    }
                } else {
                    HStack {
                        Text(Strings.listName)
                        Spacer()
                        TextField(Strings.listNamePlaceholder, text: listNameBinding)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.white)
                    }
                    .rowStyle()
                }
                
                VStack(alignment: .leading, spacing: Layout.scheduleSectionSpacing) {
                    HStack {
                        Text(Strings.scheduleForLater)
                        Spacer()
                        Toggle("", isOn: scheduleForLaterBinding)
                            .tint(ConfigColors.toggleTint)
                    }
                    .rowStyle()
                    
                    Text(Strings.scheduleInfo)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, Layout.scheduleInfoHorizontalPadding)
                }
                
                if scheduleForLater {
                    Button(action: {
                        withAnimation { showDaysPicker.toggle() }
                    }) {
                        HStack {
                            Text(Strings.scheduledDays)
                            Spacer()
                            Text(formattedScheduledDays)
                                .foregroundColor(.white)
                            Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                                .foregroundColor(.blue)
                                .rotationEffect(.degrees(showDaysPicker ? Layout.chevronRotationDegrees : 0))
                        }
                    }
                    .rowStyle()
                    .background(
                        GeometryReader { proxy in
                            Color.clear.preference(key: FramePreferenceKey.self, value: proxy.frame(in: .named("zstack_container")))
                        }
                    )
                    .zIndex(showDaysPicker ? ZIndex.activeRow : 0)
                    
                    Button(action: { delegate?.sessionConfigurationDidTapStartTime() }) {
                        HStack {
                            Text(Strings.startTime)
                            Spacer()
                            Text(formattedStartTime)
                                .foregroundColor(.white)
                            Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                                .foregroundColor(.blue)
                        }
                    }
                    .rowStyle()
                    
                    Button(action: { delegate?.sessionConfigurationDidTapEndTime() }) {
                        HStack {
                            Text(Strings.endTime)
                            Spacer()
                            Text(formattedEndTime)
                                .foregroundColor(.white)
                            Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                                .foregroundColor(.blue)
                        }
                    }
                    .rowStyle()
                } else {
                    Button(action: { delegate?.sessionConfigurationDidTapDuration() }) {
                        HStack {
                            Text(Strings.duration)
                            Spacer()
                            Text(formattedDuration)
                                .foregroundColor(.white)
                            Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                                .foregroundColor(.blue)
                        }
                    }
                    .rowStyle()
                }
                
                Button(action: { delegate?.sessionConfigurationDidTapAppsBlocked() }) {
                    HStack {
                        Text(Strings.appsBlocked)
                        Spacer()
                        Text(Strings.appsBlockedList)
                        Image(systemName: FocusSessionView.Constants.Symbols.navigationChevron)
                    }
                }
                .rowStyle()
            }
            .onPreferenceChange(FramePreferenceKey.self) { frame in
                self.dayPickerButtonFrame = frame
            }
            .padding(.horizontal)
            .foregroundColor(.white)
            
            if showDaysPicker {
                DaysPickerPopup(scheduledDays: scheduledDays, delegate: delegate)
                    .frame(width: dayPickerButtonFrame.width)
                    .offset(x: dayPickerButtonFrame.minX, y: dayPickerButtonFrame.maxY + Layout.popupYOffset)
                    .transition(.opacity.animation(.easeInOut(duration: Layout.popupAnimationDuration)))
                    .zIndex(ZIndex.popup)
            }
        }
        .coordinateSpace(name: "zstack_container")
    }
}
