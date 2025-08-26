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
                localized: "schedule_configuration_view_list_name",
                table: "SessionLocalizable",
                comment: "Label for the list name input field"
            )
            static let listNamePlaceholder = String(
                localized: "schedule_configuration_view_list_name_placeholder",
                table: "SessionLocalizable",
                comment: "Placeholder text for the list name input field"
            )
            static let scheduleForLater = String(
                localized: "schedule_configuration_view_schedule_for_later",
                table: "SessionLocalizable",
                comment: "Label for the 'Schedule for later' toggle"
            )
            static let scheduleInfo = String(
                localized: "schedule_configuration_view_schedule_info",
                table: "SessionLocalizable",
                comment: "Informational text about scheduling a blocklist"
            )
            static let duration = String(
                localized: "schedule_configuration_view_duration",
                table: "SessionLocalizable",
                comment: "Label for the duration setting"
            )
            static let appsBlocked = String(
                localized: "schedule_configuration_view_apps_blocked",
                table: "SessionLocalizable",
                comment: "Label for the 'Apps Blocked' setting"
            )
            static let appsBlockedList = String(
                localized: "schedule_configuration_view_apps_blocked_list",
                table: "SessionLocalizable",
                comment: "Value indicating the app list is available"
            )
            static let scheduledDays = String(
                localized: "schedule_configuration_view_scheduled_days",
                table: "SessionLocalizable",
                comment: "Label for the 'Scheduled Days' setting"
            )
            
            // Schedule picker.
            static let startTimeTitle = String(
                localized: "schedule_configuration_view_start_time_title",
                table: "SessionLocalizable",
                comment: "Title for start time"
            )
            static let startTimeSubtitle = String(
                localized: "schedule_configuration_view_start_time_subtitle",
                table: "SessionLocalizable",
                comment: "Title for start session subtitle"
            )
            static let endTimeTitle = String(
                localized: "schedule_configuration_view_end_time_title",
                table: "SessionLocalizable",
                comment: "Title for end time"
            )
            static let endTimeSubtitle = String(
                localized: "schedule_configuration_view_end_time_subtitle",
                table: "SessionLocalizable",
                comment: "Title for end session subtitle"
            )
            
            // Duration picker.
            static let durationPickerTitle = String(
                localized: "schedule_configuration_view_duration_picker_title",
                table: "SessionLocalizable",
                comment: "Title for the duration picker sheet"
            )
            static let durationPickerSubtitle = String(
                localized: "schedule_configuration_view_duration_picker_subtitle",
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
