//
//  TimePickerSheetView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 20.06.25.
//

import SwiftUI

struct TimePickerSheetView: View {
    @State private var selectedDate: Date
    weak var delegate: TimePickerSheetViewDelegate?
    let title: String
    let subtitle: String
    let pickerType: TimePickerType
    
    init(initialDate: Date, title: String, subtitle: String, pickerType: TimePickerType, delegate: TimePickerSheetViewDelegate?) {
        self._selectedDate = State(initialValue: initialDate)
        self.title = title
        self.subtitle = subtitle
        self.pickerType = pickerType
        self.delegate = delegate
    }
    
    private typealias Layout = FocusSessionView.Constants.TimePicker.Layout
    private typealias Strings = FocusSessionView.Constants.TimePicker.Strings
    private typealias Colors = FocusSessionView.Constants.TimePicker.Colors
    
    private var hours: Binding<Int> {
        Binding(
            get: { Calendar.current.component(.hour, from: selectedDate) },
            set: { newHour in
                let current = Calendar.current
                if let newDate = current.date(bySettingHour: newHour, minute: current.component(.minute, from: selectedDate), second: 0, of: selectedDate) {
                    selectedDate = newDate
                }
            }
        )
    }
    
    private var minutes: Binding<Int> {
        Binding(
            get: { Calendar.current.component(.minute, from: selectedDate) },
            set: { newMinute in
                let current = Calendar.current
                if let newDate = current.date(bySettingHour: current.component(.hour, from: selectedDate), minute: newMinute, second: 0, of: selectedDate) {
                    selectedDate = newDate
                }
            }
        )
    }
    
    var body: some View {
        ZStack {
            FocusSessionView.Constants.Colors.sheetBackground
                .ignoresSafeArea()
            
            VStack(spacing: Layout.mainSpacing) {
                Capsule()
                    .fill(Color.gray)
                    .frame(width: Layout.dragIndicatorWidth, height: Layout.dragIndicatorHeight)
                
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.blue)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                ZStack {
                    Colors.pickerBackground
                    
                    timePicker
                        .padding(.bottom)
                }
                .frame(width: Layout.containerWidth, height: Layout.containerHeight)
                .cornerRadius(Layout.containerCornerRadius)
            }
            .foregroundColor(.white)
        }
        .onDisappear {
            delegate?.timePickerDidSave(date: selectedDate, type: pickerType)
        }
    }
    
    private var timePicker: some View {
        HStack(spacing: 0) {
            Picker(Strings.hoursPickerTitle, selection: hours) {
                ForEach(0..<FocusSessionView.Constants.Time.hoursInDay, id: \.self) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: Layout.pickerWidth)
            .clipped()
            
            Picker(Strings.minutesPickerTitle, selection: minutes) {
                ForEach(0..<FocusSessionView.Constants.Time.minutesInHour, id: \.self) { minute in
                    Text("\(minute)").tag(minute)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: Layout.pickerWidth)
            .clipped()
        }
    }
}
