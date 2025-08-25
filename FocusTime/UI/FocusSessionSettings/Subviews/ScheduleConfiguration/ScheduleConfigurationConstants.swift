//
//  ScheduleConfigurationConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 03.07.25.
//

import SwiftUI

extension ScheduleConfigurationView {
    // MARK: - Constants for ScheduleConfigurationView
    enum Constants {
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
            static let scheduledDays = String(
                localized: "Scheduled Days",
                table: "SessionLocalizable",
                comment: "Label for the 'Scheduled Days' setting"
            )
            
            // Schedule picker.
            static let startTimeTitle = String(
                localized: "Start Time",
                table: "Localizable",
                comment: "Title for start time"
            )
            static let startTimeSubtitle = String(
                localized: "Choose when the session starts",
                table: "Localizable",
                comment: "Title for start session subtitle"
            )
            static let endTimeTitle = String(
                localized: "End Time",
                table: "Localizable",
                comment: "Title for end time"
            )
            static let endTimeSubtitle = String(
                localized: "Choose when the session ends",
                table: "Localizable",
                comment: "Title for end session subtitle"
            )
            
            // Duration picker.
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
        }
        
        enum Layout {
            static let mainSpacing: CGFloat = 16
            static let scheduleSectionSpacing: CGFloat = 8
            static let listIconSpacing: CGFloat = 12
        }
        
        enum Colors {
            static let toggleTint = Color.green
            static let chevronColor = Color.blue
        }
        
        enum Symbols {
            static let navigationChevron = "chevron.right"
        }
        
        enum DefaultValues {
            public static let minuteInterval: Int = 15
        }
    }
}
