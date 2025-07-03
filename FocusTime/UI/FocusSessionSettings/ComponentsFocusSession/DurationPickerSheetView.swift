//
//  DurationPickerSheetView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import SwiftUI
// import FocusTimeUI // No longer explicitly needed as constants are accessed via FocusSessionView

struct DurationPickerSheetView: View {
    // MARK: - Properties
    // Use @Binding for hours and minutes to allow parent view to update them directly
    @Binding var hours: Int
    @Binding var minutes: Int

    // No custom init needed, Swift provides memberwise init for @Binding properties.

    // MARK: - Body
    var body: some View {
        ZStack {
            FocusSessionView.Constants.Colors.sheetBackground
                .ignoresSafeArea()

            VStack(spacing: FocusSessionView.Constants.DurationPicker.Layout.mainSpacing) {
                // Comment addressed: Removed custom grabber as system provides it.
                // FocusSessionView sets .presentationDragIndicator(.hidden) so no grabber will be shown.

                Text(FocusSessionView.Constants.DurationPicker.Strings.title)
                    .font(.title2.bold()) // Comment addressed: Increased font size
                    .foregroundStyle(Color.blue)

                Text(FocusSessionView.Constants.DurationPicker.Strings.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom)

                // Comment addressed: Using .background {} for clarity
                durationPicker
                    .padding(.bottom)
                    .frame(width: FocusSessionView.Constants.DurationPicker.Layout.containerWidth, height: FocusSessionView.Constants.DurationPicker.Layout.containerHeight)
                    .background { // Applied background using a closure
                        FocusSessionView.Constants.DurationPicker.Colors.pickerBackground
                            .cornerRadius(FocusSessionView.Constants.DurationPicker.Layout.containerCornerRadius)
                    }
            }
            // Comment addressed: Removed .foregroundColor(.white) as preferredColorScheme(.dark) should handle this.
            // If specific text elements need white, apply .foregroundStyle(.white) to them individually.
        }
        // No .onDisappear needed for saving values, as @Binding updates the source directly.
    }

    // MARK: - Private Views
    private var durationPicker: some View {
        HStack(spacing: 0) {
            Picker(FocusSessionView.Constants.DurationPicker.Strings.hoursPickerTitle, selection: $hours) {
                ForEach(0..<FocusSessionView.Constants.Time.hoursInDay, id: \.self) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: FocusSessionView.Constants.DurationPicker.Layout.pickerWidth)
            .clipped()

            Picker(FocusSessionView.Constants.DurationPicker.Strings.minutesPickerTitle, selection: $minutes) {
                ForEach(0..<FocusSessionView.Constants.Time.minutesInHour, id: \.self) { minute in
                    Text("\(minute)").tag(minute)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: FocusSessionView.Constants.DurationPicker.Layout.pickerWidth)
            .clipped()
        }
    }
}
