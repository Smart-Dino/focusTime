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
    }
}
