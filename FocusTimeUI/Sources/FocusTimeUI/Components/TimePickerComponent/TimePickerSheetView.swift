//
//  TimePickerSheetView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 20.06.25.
//

import SwiftUI

public struct TimePickerSheetView: View {
    @Binding public var selectedDate: Date
    public let title: String
    public let subtitle: String

    public init(selectedDate: Binding<Date>, title: String, subtitle: String) {
        _selectedDate = selectedDate
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        ZStack {
            Color.ftPresetBackgroundColor
                .ignoresSafeArea()

            VStack(spacing: TimePickerConstants.Layout.mainSpacing) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.blue)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .padding(.bottom)

                timePicker
                    .padding(.bottom)
                    .frame(width: TimePickerConstants.Layout.containerWidth, height: TimePickerConstants.Layout.containerHeight)
                    .background {
                        Color.ftTimePickerBackgroundColor
                            .cornerRadius(TimePickerConstants.Layout.containerCornerRadius)
                    }
            }
        }
        .presentationDragIndicator(.visible)
    }

    private var timePicker: some View {
        DatePicker(
            "",
            selection: $selectedDate,
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .frame(width: TimePickerConstants.Layout.pickerWidth)
        .clipped()
        .environment(\.locale, Locale(identifier: "en_CH"))
    }
}
