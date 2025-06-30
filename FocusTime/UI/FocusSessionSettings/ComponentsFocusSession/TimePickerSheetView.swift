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
    
    @State private var internalHours: Int
    @State private var internalMinutes: Int
    
    init(initialDate: Date, title: String, subtitle: String, pickerType: TimePickerType, delegate: TimePickerSheetViewDelegate?) {
        self._selectedDate = State(initialValue: initialDate)
        self.title = title
        self.subtitle = subtitle
        self.pickerType = pickerType
        self.delegate = delegate
        
        _internalHours = State(initialValue: Calendar.current.component(.hour, from: initialDate))
        _internalMinutes = State(initialValue: Calendar.current.component(.minute, from: initialDate))
    }
    
    private typealias Layout = FocusSessionView.Constants.TimePicker.Layout
    private typealias Strings = FocusSessionView.Constants.TimePicker.Strings
    private typealias Colors = FocusSessionView.Constants.TimePicker.Colors
    
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
        .onChange(of: internalHours) {
            updateSelectedDate(hours: internalHours, minutes: internalMinutes)
        }
        .onChange(of: internalMinutes) {
            updateSelectedDate(hours: internalHours, minutes: internalMinutes)
        }
        .onDisappear {

            delegate?.timePickerDidSave(date: selectedDate, type: pickerType)
        }
    }
    
    private var timePicker: some View {
        HStack(spacing: 0) {
            Picker(Strings.hoursPickerTitle, selection: $internalHours) {
                ForEach(0..<FocusSessionView.Constants.Time.hoursInDay, id: \.self) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: Layout.pickerWidth)
            .clipped()
            .environment(\.locale, Locale(identifier: "en_GB"))

            Picker(Strings.minutesPickerTitle, selection: $internalMinutes) {
                ForEach(0..<FocusSessionView.Constants.Time.minutesInHour, id: \.self) { minute in
                    Text("\(minute)").tag(minute)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: Layout.pickerWidth)
            .clipped()
            .environment(\.locale, Locale(identifier: "en_GB"))
        }
    }
    
    private func updateSelectedDate(hours: Int, minutes: Int) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        components.hour = hours
        components.minute = minutes
        
        if let newDate = calendar.date(from: components) {
            selectedDate = newDate
        }
    }
}
