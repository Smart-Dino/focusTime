//
//  TimePickerSheetView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 20.06.25.
//

import SwiftUI

struct TimePickerSheetView: View {
    // MARK: - Properties
    @Binding var selectedDate: Date // Changed to Binding
    let title: String
    let subtitle: String
    let pickerType: TimePickerType // Keep pickerType for potential logic within ViewModel if it existed

    // Removed internalHours, internalMinutes, and custom init.
    // Swift will synthesize a memberwise initializer for @Binding and let properties.

    // MARK: - Body
    var body: some View {
        ZStack {
            FocusSessionView.Constants.Colors.sheetBackground
                .ignoresSafeArea()

            VStack(spacing: FocusSessionView.Constants.TimePicker.Layout.mainSpacing) {
                // Comment addressed: Removed custom grabber, system handles it
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.blue)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom)

                // Comment addressed: Using .background {} for clarity
                timePicker
                    .padding(.bottom)
                    .frame(width: FocusSessionView.Constants.TimePicker.Layout.containerWidth, height: FocusSessionView.Constants.TimePicker.Layout.containerHeight)
                    .background { // Applied background using a closure
                        FocusSessionView.Constants.TimePicker.Colors.pickerBackground
                            .cornerRadius(FocusSessionView.Constants.TimePicker.Layout.containerCornerRadius)
                    }
            }
            // Comment addressed: Removed .foregroundColor(.white)
        }
        // No .onChange or .onDisappear needed, as @Binding directly updates selectedDate.
    }

    // MARK: - Private Views
    private var timePicker: some View {
        // Using SwiftUI's native DatePicker for time selection
        DatePicker(
            "",
            selection: $selectedDate, // Binding directly to selectedDate
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden() // Hide default labels for cleaner look if not needed
        .frame(width: FocusSessionView.Constants.TimePicker.Layout.pickerWidth)
        .clipped()
        .environment(\.locale, Locale(identifier: "en_GB")) // Keep locale if specific formatting is desired
    }
}
