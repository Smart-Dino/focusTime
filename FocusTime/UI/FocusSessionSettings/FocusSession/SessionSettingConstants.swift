//
//  SessionSettingConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import SwiftUI

extension FocusSessionView {
    
    enum Constants {
        // MARK: - General Strings
        enum Strings {
            static let navigationTitle = String(
                localized: "Focus Setup",
                table: "SessionLocalizable",
                comment: "Navigation title for the focus session setup screen"
            )
            static let startButtonTitle = String(
                localized: "Start",
                table: "SessionLocalizable",
                comment: "Title for the start button"
            )
            static let durationPickerSheetErrorTitle = String(
                localized: "Error: DurationPickerSheetViewModel not initialized.",
                table: "SessionLocalizable",
                comment: "Error message for duration picker"
            )
            static let defaultListName = String(
                localized: "Focus Session",
                table: "SessionLocalizable",
                comment: "Default name for a new focus session"
            )
        }
        
        // MARK: - General Layout
        enum Layout {
            static let mainVStackSpacing: CGFloat = 40
            static let sheetHeight: CGFloat = 400
            static let sheetCornerRadius: CGFloat = 25
            static let floatingButtonHorizontalPadding: CGFloat = 20
        }
        
        // MARK: - General Colors
        enum Colors {
            static let chevronColor = Color.blue
        }
        
        // MARK: - Symbols
        enum Symbols {
            static let startButtonIcon = "hourglass"
            static let navigationChevron = "chevron.right"
        }
        
        // MARK: - Default Values for ViewModel
        enum DefaultValues {
            static let listName = Constants.Strings.defaultListName
            static let durationHours = 0
            static let durationMinutes = 30
            static let startTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            static let endTime: Date = Calendar.current.date(from: DateComponents(hour: 17, minute: 0))!
            static let initialFocusPreset: FocusPreset? = FocusPreset.allCases.randomElement()
        }
    }
}
