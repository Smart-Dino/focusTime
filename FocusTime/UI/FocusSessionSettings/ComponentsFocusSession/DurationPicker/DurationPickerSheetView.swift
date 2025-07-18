//
//  DurationPickerSheetView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI

struct DurationPickerSheetView: View {
    // MARK: - Properties
    @Binding var hours: Int
    @Binding var minutes: Int
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.ftPresetBackgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: FocusSessionView.Constants.DurationPicker.Layout.mainSpacing) {
                Text(FocusSessionView.Constants.DurationPicker.Strings.durationPickerTitle)
                    .font(.title2.bold())
                    .foregroundStyle(.blue)
                
                Text(FocusSessionView.Constants.DurationPicker.Strings.durationPickerSubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .padding(.bottom)
                
                durationPicker
                    .padding(.bottom)
                    .frame(width: FocusSessionView.Constants.DurationPicker.Layout.containerWidth, height: FocusSessionView.Constants.DurationPicker.Layout.containerHeight)
                    .background {
                        Color.ftTimePickerBackgroundColor
                            .cornerRadius(FocusSessionView.Constants.DurationPicker.Layout.containerCornerRadius)
                    }
            }
        }
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Private Views
    private var durationPicker: some View {
        HStack(spacing: 0) {
            Picker(
                FocusSessionView.Constants.DurationPicker.Strings.hoursPickerTitle,
                selection: $hours
            ) {
                ForEach(0..<FocusSessionView.Constants.DurationPicker.Time.hoursInDay, id: \.self) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: FocusSessionView.Constants.DurationPicker.Layout.pickerWidth)
            .clipped()
            
            Picker(
                FocusSessionView.Constants.DurationPicker.Strings.minutesPickerTitle,
                selection: $minutes
            ) {
                ForEach(0..<FocusSessionView.Constants.DurationPicker.Time.minutesInHour, id: \.self) { minute in
                    Text("\(minute)").tag(minute)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: FocusSessionView.Constants.DurationPicker.Layout.pickerWidth)
            .clipped()
        }
    }
}
