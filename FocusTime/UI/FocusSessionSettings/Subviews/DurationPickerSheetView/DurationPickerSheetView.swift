//
//  DurationPickerSheetView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI
import FocusTimeUI

struct DurationPickerSheetView: View {
    // MARK: - Properties
    @Binding var hours: Int
    @Binding var minutes: Int
    
    let title: String
    let subtitle: String
    
    // MARK: - Body
    var body: some View {
        VStack {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.ftMainBlue)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.ftGray3Light)
                .padding(.bottom)
            
            durationPicker
                .padding(.bottom)
                .frame(height: Constants.Layout.containerHeight)
                .background {
                    Color.ftWheelTimePickerBackgroundColor
                        .cornerRadius(Constants.Layout.containerCornerRadius)
                }
                .padding(.horizontal, Constants.Layout.containerWidthPadding)
        }
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Private Views
    private var durationPicker: some View {
        HStack(spacing: 0) {
            Picker(
                Constants.Strings.hoursPickerTitle,
                selection: $hours
            ) {
                ForEach(0..<Constants.Time.hoursInDay, id: \.self) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            .padding(.trailing, -15)
            .clipped()
            
            Picker(
                Constants.Strings.minutesPickerTitle,
                selection: $minutes
            ) {
                ForEach(1..<Constants.Time.minutesInHour, id: \.self) { minute in
                    Text("\(minute)").tag(minute)
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            .padding(.leading, -15)
            .clipped()
        }
    }
}

