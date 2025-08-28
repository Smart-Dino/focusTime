//
//  TimePickerSheetView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 20.06.25.
//

import SwiftUI
import FocusTimeUI

struct TimePickerSheetView: View {
    @Binding var selectedDate: Date
    let title: String
    let subtitle: String
    let minuteInterval: Int?
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.ftMainBlue)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.ftGray3Light)
                .padding(.bottom)
            
            timePicker
                .padding(.bottom)
                .frame(height: Constants.Layout.containerHeight)
                .background {
                    Color.ftWheelTimePickerBackgroundColor
                        .cornerRadius(Constants.Layout.containerCornerRadius)
                }
                .padding(.horizontal, Constants.Layout.pickerWidthPadding)
                .onAppear {
                    if let minuteInterval {
                        UIDatePicker.appearance().minuteInterval = minuteInterval
                    }
                }
        }
        .presentationDragIndicator(.visible)
    }
    
    var timePicker: some View {
        DatePicker(
            String(),
            selection: $selectedDate,
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .clipped()
    }
    
    init(
        selectedDate: Binding<Date>,
        title: String,
        subtitle: String,
        minuteInterval: Int? = nil
    ) {
        _selectedDate = selectedDate
        self.title = title
        self.subtitle = subtitle
        self.minuteInterval = minuteInterval
    }
    
}

