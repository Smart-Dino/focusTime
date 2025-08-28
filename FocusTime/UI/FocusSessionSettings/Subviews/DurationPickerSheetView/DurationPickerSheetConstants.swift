//
//  DurationPickerSheetConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 02.07.25.
//

import SwiftUI

extension DurationPickerSheetView {
    enum Constants {
        // MARK: - Constants for DurationPickerSheetView
        enum Time {
            static let hoursInDay = 24
            static let minutesInHour = 60
        }
        
        enum Strings {
            static let hoursPickerTitle = String(
                localized: "duration_picker_sheet_view_hours_picker_title",
                table: "SessionLocalizable",
                comment: "Label for hours picker in duration sheet"
            )
            static let minutesPickerTitle = String(
                localized: "duration_picker_sheet_view_minutes_picker_title",
                table: "SessionLocalizable",
                comment: "Label for minutes picker in duration sheet"
            )
        }
        
        enum Layout {
            static let containerWidthPadding: CGFloat = 140
            static let containerHeight: CGFloat = 213
            static let containerCornerRadius: CGFloat = 13
        }
    }
}
