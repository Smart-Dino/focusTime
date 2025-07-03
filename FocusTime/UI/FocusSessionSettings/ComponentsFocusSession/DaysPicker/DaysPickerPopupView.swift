//
//  DaysPickerPopupView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 23.06.25.
//

import SwiftUI

struct DaysPickerPopup: View {
    // MARK: - Properties
    @Binding var scheduledDays: Set<Weekday> // Changed from let and delegate

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Weekday.allCases.sorted()) { day in
                Button(action: {
                    // Directly modify the bound scheduledDays
                    if scheduledDays.contains(day) {
                        scheduledDays.remove(day)
                    } else {
                        scheduledDays.insert(day)
                    }
                }) {
                    HStack(spacing: FocusSessionView.Constants.DaysPickerPopup.Layout.itemSpacing) {
                        Image(systemName: FocusSessionView.Constants.DaysPickerPopup.Symbols.checkmark)
                            .font(.body.weight(.bold))
                            .opacity(scheduledDays.contains(day) ? 1 : 0)
                        Text(day.rawValue.capitalized)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, FocusSessionView.Constants.DaysPickerPopup.Layout.verticalPadding)
                    .foregroundColor(.white)
                }
                if day != Weekday.allCases.sorted().last {
                    Divider()
                        .background(FocusSessionView.Constants.DaysPickerPopup.Colors.divider)
                        .padding(.horizontal)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: FocusSessionView.Constants.DaysPickerPopup.Layout.cornerRadius)
                .fill(FocusSessionView.Constants.DaysPickerPopup.Colors.background)
        )
        .compositingGroup()
        .shadow(color: FocusSessionView.Constants.DaysPickerPopup.Colors.shadow, radius: FocusSessionView.Constants.DaysPickerPopup.Layout.shadowRadius, y: FocusSessionView.Constants.DaysPickerPopup.Layout.shadowY)
    }
}
