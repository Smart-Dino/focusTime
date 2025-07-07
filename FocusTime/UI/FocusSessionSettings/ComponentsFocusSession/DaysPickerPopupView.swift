//
//  DaysPickerPopupView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 23.06.25.
//

import SwiftUI
import FocusTimeUI 

struct DaysPickerPopup: View {
    // MARK: - Properties
    @Binding var scheduledDays: Set<Weekday>

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Weekday.allCases.sorted()) { day in
                Button {
                    if scheduledDays.contains(day) {
                        scheduledDays.remove(day)
                    } else {
                        scheduledDays.insert(day)
                    }
                } label: {
                    HStack(spacing: FocusSessionView.Constants.DaysPickerPopup.Layout.itemSpacing) {
                        Image(systemName: FocusSessionView.Constants.DaysPickerPopup.Symbols.checkmark)
                            .font(.body.weight(.bold))
                            .opacity(scheduledDays.contains(day) ? 1 : 0)
                        Text(LocalizedStringKey(day.rawValue.capitalized))
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
                .fill(Color.ftDaysPickerBackground)
        )
        .compositingGroup()
        .shadow(color: FocusSessionView.Constants.DaysPickerPopup.Colors.shadow, radius: FocusSessionView.Constants.DaysPickerPopup.Layout.shadowRadius, y: FocusSessionView.Constants.DaysPickerPopup.Layout.shadowY)
    }
}
