//
//  FocusSessionConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import SwiftUI

extension FocusSessionView {
    
    enum Constants {
        // MARK: - General Strings
        enum Strings {
            static let emojis = ["☕️", "⏳", "📖", "🌿", "💪", "💻", "🚀", "⚡️"]
            static let navigationTitle = String(
                localized: "focus_session_view_navigation_title",
                table: "SessionLocalizable",
                comment: "Navigation title for the focus session setup screen"
            )
            static let startButtonTitle = String(
                localized: "focus_session_view_start_button_title",
                table: "SessionLocalizable",
                comment: "Title for the start button"
            )
        }
        
        // MARK: - General Layout
        enum Layout {
            static let mainVStackSpacing: CGFloat = 40
            static let sheetHeight: CGFloat = 400
            static let sheetCornerRadius: CGFloat = 25
            static let floatingButtonHorizontalPadding: CGFloat = 20
        }
        
        // MARK: - Symbols
        enum Symbols {
            static let startButtonIcon = "hourglass"
        }
        
        enum DefaultValues {
            static let durationHours = 0
            static let durationMinutes = 30
            static let startTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            static let endTime: Date = Calendar.current.date(from: DateComponents(hour: 17, minute: 0))!
        }
    }
}
