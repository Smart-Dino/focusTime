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
            static let emojis = SharedConstants.Strings.defaultEmojis
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
            static let deletePresetButtonTitle = String(
                localized: "focus_session_view_delete_preset_button_title",
                table: "SessionLocalizable",
                comment: "Title for the delete preset button"
            )
            static let deleteConfirmationAlertTitle = String(
                localized: "focus_session_view_delete_alert_title",
                table: "SessionLocalizable",
                comment: "Title for the delete confirmation alert"
            )
            static let deleteConfirmationAlertDeleteButton = String(
                localized: "focus_session_view_delete_alert_delete_button",
                table: "SessionLocalizable",
                comment: "Title for the delete confirmation button in the alert"
            )
            static let deleteConfirmationAlertCancelButton = String(
                localized: "focus_session_view_delete_alert_cancel_button",
                table: "SessionLocalizable",
                comment: "Title for the cancel button in the alert"
            )
            static let startFocusingButtonTitle = String(
                localized: "focus_session_view_start_focusing_button_title",
                table: "SessionLocalizable",
                comment: "Title for the 'Start Focusing' button when editing a preset"
            )
            static let activateScheduleButtonTitle = String(
                localized: "focus_session_view_activate_schedule_button_title",
                table: "SessionLocalizable",
                comment: "Title for activating a schedule"
            )
            static let deactivateScheduleButtonTitle = String(
                localized: "focus_session_view_deactivate_schedule_button_title",
                table: "SessionLocalizable",
                comment: "Title for deactivating a schedule"
            )
            static let saveButtonTitle = String(
                localized: "focus_session_view_save_button_title",
                table: "SessionLocalizable",
                comment: "Title for the save button"
            )
        }
        
        // MARK: - General Layout
        enum Layout {
            static let mainVStackSpacing: CGFloat = 40
            static let sheetHeight: CGFloat = 400
            static let sheetCornerRadius: CGFloat = 25
            static let floatingButtonPadding: CGFloat = 20
            static let deleteButtonHeight: CGFloat = 50
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
