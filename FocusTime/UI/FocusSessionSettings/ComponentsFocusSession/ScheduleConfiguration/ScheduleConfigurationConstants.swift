//
//  ScheduleConfigurationConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 03.07.25.
//

import SwiftUI

extension FocusSessionView.Constants {
    // MARK: - Constants for ScheduleConfigurationView
    enum Configuration {
        enum Strings {
            static let listName = String(
                localized: "List name",
                table: "SessionLocalizable",
                comment: "Label for the list name input field"
            )
            static let listNamePlaceholder = String(
                localized: "Name",
                table: "SessionLocalizable",
                comment: "Placeholder text for the list name input field"
            )
            static let scheduleForLater = String(
                localized: "Schedule for later",
                table: "SessionLocalizable",
                comment: "Label for the 'Schedule for later' toggle"
            )
            static let scheduleInfo = String(
                localized: "Turn on to have this blocklist activate automatically based on your scheduled days and times.",
                table: "SessionLocalizable",
                comment: "Informational text about scheduling a blocklist"
            )
            static let duration = String(
                localized: "Duration",
                table: "SessionLocalizable",
                comment: "Label for the duration setting"
            )
            static let appsBlocked = String(
                localized: "Apps Blocked",
                table: "SessionLocalizable",
                comment: "Label for the 'Apps Blocked' setting"
            )
            static let appsBlockedList = String(
                localized: "List",
                table: "SessionLocalizable",
                comment: "Value indicating the app list is available"
            )
            static let appListPickerDestination = String(
                localized: "App List Picker Screen",
                table: "SessionLocalizable",
                comment: "Accessibility label or destination title for app list picker"
            )
            static let scheduledDays = String(
                localized: "Scheduled Days",
                table: "SessionLocalizable",
                comment: "Label for the 'Scheduled Days' setting"
            )
            static let startTime = String(
                localized: "Start time",
                table: "SessionLocalizable",
                comment: "Label for the start time setting"
            )
            static let endTime = String(
                localized: "End time",
                table: "SessionLocalizable",
                comment: "Label for the end time setting"
            )
        }
        
        enum Layout {
            static let mainSpacing: CGFloat = 16
            static let scheduleSectionSpacing: CGFloat = 8
            static let listIconSpacing: CGFloat = 12
            static let selectedIconSize: CGFloat = 36
            static let scheduledDaysTextPadding: CGFloat = 16
        }
        
        enum Colors {
            static let toggleTint = Color.green
        }
        
        enum DefaultValues {
            static let durationHours = 0
            static let durationMinutes = 30
            static let startTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            static let endTime: Date = Calendar.current.date(from: DateComponents(hour: 17, minute: 0))!
        }
    }
}
