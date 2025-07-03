//
//  TimePickerSheetView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 20.06.25.
//

import SwiftUI

struct TimePickerSheetView: View {
    // MARK: - Properties
    @Binding var selectedDate: Date
    let title: String
    let subtitle: String
    let pickerType: TimePickerType // Keep pickerType for potential logic within ViewModel if it existed

    // MARK: - Body
    var body: some View {
        ZStack {
            FocusSessionView.Constants.Colors.sheetBackground
                .ignoresSafeArea()

            VStack(spacing: FocusSessionView.Constants.TimePicker.Layout.mainSpacing) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.blue)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom)

                timePicker
                    .padding(.bottom)
                    .frame(width: FocusSessionView.Constants.TimePicker.Layout.containerWidth, height: FocusSessionView.Constants.TimePicker.Layout.containerHeight)
                    .background {
                        FocusSessionView.Constants.TimePicker.Colors.pickerBackground
                            .cornerRadius(FocusSessionView.Constants.TimePicker.Layout.containerCornerRadius)
                    }
            }
        }
    }

    // MARK: - Private Views
    private var timePicker: some View {
        DatePicker(
            "",
            selection: $selectedDate,
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .frame(width: FocusSessionView.Constants.TimePicker.Layout.pickerWidth)
        .clipped()
        .environment(\.locale, Locale(identifier: "en_GB"))
    }
}
