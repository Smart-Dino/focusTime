//
//  DaysPickerPopup.swift
//  FocusTime
//
//  Created by Keto Nioradze on 23.06.25.
//

import SwiftUI

struct DaysPickerPopup: View {
    let scheduledDays: Set<Weekday>
    weak var delegate: SessionConfigurationViewDelegate?
    
    private typealias Layout = FocusSessionView.Constants.DaysPickerPopup.Layout
    private typealias Colors = FocusSessionView.Constants.DaysPickerPopup.Colors
    private typealias Symbols = FocusSessionView.Constants.DaysPickerPopup.Symbols
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Weekday.allCases.sorted()) { day in
                Button(action: { delegate?.sessionConfigurationDidToggleDay(day) }) {
                    HStack(spacing: Layout.itemSpacing) {
                        Image(systemName: Symbols.checkmark)
                            .font(.body.weight(.bold))
                            .opacity(scheduledDays.contains(day) ? 1 : 0)
                        Text(day.rawValue.capitalized)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, Layout.verticalPadding)
                    .foregroundColor(.white)
                }
                if day != Weekday.allCases.sorted().last {
                    Divider()
                        .background(Colors.divider)
                        .padding(.horizontal)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .fill(Colors.background)
        )
        .compositingGroup()
        .shadow(color: Colors.shadow, radius: Layout.shadowRadius, y: Layout.shadowY)
    }
}
