//
//  PickerSheetConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 02.07.25.
//

import SwiftUI

extension FocusSessionView.Constants {
    
    // MARK: - Constants for DurationPickerSheetView
    enum DurationPicker {
        
        enum Time {
            static let hoursInDay = 24
            static let minutesInHour = 60
        }
        
        enum Strings {
            static let durationPickerTitle = String(
                localized: "Session Length",
                table: "SessionLocalizable",
                comment: "Title for the duration picker sheet"
            )
            static let durationPickerSubtitle = String(
                localized: "Choose how long you want to stay focused",
                table: "SessionLocalizable",
                comment: "Subtitle for the duration picker sheet"
            )
            static let hoursPickerTitle = String(
                localized: "Hours",
                table: "SessionLocalizable",
                comment: "Label for hours picker in duration sheet"
            )
            static let minutesPickerTitle = String(
                localized: "Minutes",
                table: "SessionLocalizable",
                comment: "Label for minutes picker in duration sheet"
            )
        }
        
        enum Layout {
            static let containerWidth: CGFloat = 139
            static let containerHeight: CGFloat = 213
            static let containerCornerRadius: CGFloat = 13
            static let pickerWidth: CGFloat = 70
            static let activePickerWidth: CGFloat = 134
            static let activePickerHeight: CGFloat = 35
            static let activePickerCornerRadius: CGFloat = 7
        }
        
        enum Colors {
            static let pickerBackground = Color(.darkGray).opacity(0.1)
        }
    }
}
