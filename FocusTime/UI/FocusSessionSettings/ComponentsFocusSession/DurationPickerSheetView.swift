//
//  DurationPickerSheetView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI
import FocusTimeUI

struct DurationPickerSheetView: View {
    
    @State private var hours: Int
    @State private var minutes: Int
    
    weak var delegate: DurationPickerSheetViewDelegate?
    
    init(initialHours: Int, initialMinutes: Int, delegate: DurationPickerSheetViewDelegate?) {
        self._hours = State(initialValue: initialHours)
        self._minutes = State(initialValue: initialMinutes)
        self.delegate = delegate
    }
    
    private typealias Strings = FocusSessionView.Constants.DurationPicker.Strings
    private typealias Layout = FocusSessionView.Constants.DurationPicker.Layout
    private typealias Colors = FocusSessionView.Constants.DurationPicker.Colors
    
    var body: some View {
        ZStack {
            FocusSessionView.Constants.Colors.sheetBackground
                .ignoresSafeArea()
            
            VStack(spacing: Layout.mainSpacing) {
                Capsule()
                    .fill(Color.gray)
                    .frame(width: Layout.dragIndicatorWidth, height: Layout.dragIndicatorHeight)
                
                Text(Strings.title)
                    .font(.headline)
                    .foregroundStyle(Color.blue)
                
                Text(Strings.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                ZStack {
                    Colors.pickerBackground
                    
                    durationPicker
                        .padding(.bottom)
                }
                .frame(width: Layout.containerWidth, height: Layout.containerHeight)
                .cornerRadius(Layout.containerCornerRadius)
            }
            .foregroundColor(.white)
        }
        .onDisappear {
            delegate?.durationPickerDidSave(hours: hours, minutes: minutes)
        }
    }
    
    private var durationPicker: some View {
        HStack(spacing: 0) {
            Picker(Strings.hoursPickerTitle, selection: $hours) {
                ForEach(0..<FocusSessionView.Constants.Time.hoursInDay, id: \.self) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: Layout.pickerWidth)
            .clipped()
            
            Picker(Strings.minutesPickerTitle, selection: $minutes) {
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



