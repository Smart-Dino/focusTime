//
//  ScheduleConfigurationConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 03.07.25.
//

import SwiftUI
import FocusTimeUI

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
                comment: "Value indicating an empty list"
            )
            
            static func appsBlockedListWithCounts(categoriesCount: Int, appsCount: Int) -> String {
                let format = String(localized: "schedule_configuration_view_apps_blocked_list_with_counts",
                                    table: "SessionLocalizable",
                                    comment: "Shows the number of selected categories and apps")
                return String(format: format, categoriesCount, appsCount)
            }

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
            static let toggleTint = Color.ftMainBlue
            static let chevronColor = Color.blue
        }
        
        enum Symbols {
            static let navigationChevron = "chevron.right"
        }
        
        enum DefaultValues {
            public static let minuteInterval: Int = 15
            
            static let durationHours = 0
            static let durationMinutes = 30
            static let startTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            static let endTime: Date = Calendar.current.date(from: DateComponents(hour: 17, minute: 0))!
        }
        
        
        enum ScheduleSessionAnalyticsKeys: String {
            case setListName = "setted_list_name"
            case presetSelected = "preset_selected"
            case startButtonTapped = "start_button_tapped"
            case endButtonTapped = "end_button_tapped"
            case setMinutes = "set_minutes"
            case setHours = "set_hours"
            case scheduledForLaterToggled = "scheduled_for_later_toggled"
            case durationPickerPresented = "duration_picker_presented"
            case timePickerPresented = "time_picker_presented"
            case appBlockerSheetPresented = "app_blocker_sheet_presented"
            case setCustomEmoji = "custom_emoji_selected"
            case scheduledDayAdded = "scheduled_day_added"
            case scheduledDayRemoved = "scheduled_day_removed"
            case dismissSheet = "sheet_dismissed"
        }
        
        struct ScheduleSessionAnalyticsParameterKey {
            static let presetName = "preset_name"
            static let listname = "listname"
            static let scheduleForLater = "schedule_for_later"
            static let scheduledDay = "scheduled_day"
            static let customEmoji = "emoji"
            static let setHours = "hours"
            static let setMinutes = "minutes"
            static let startTime = "start_time"
            static let endTime = "end_time"
            static let timePickerType = "time_picker_type"
        }
    }
}
