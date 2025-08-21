//
//  AnalyticsKey.swift
//  FocusTime
//
//  Created by Keto Nioradze on 21.08.25.
//

import Foundation

/// Defines all analytics event names used in the application.
enum AnalyticsEvent: String {
    case presetSelected = "preset_selected"
    case startButtonTapped = "start_button_tapped"
    case scheduledForLaterToggled = "scheduled_for_later_toggled"
    case durationPickerPresented = "duration_picker_presented"
    case timePickerPresented = "time_picker_presented"
    case appBlockerSheetPresented = "app_blocker_sheet_presented"
    case customEmojiSelected = "custom_emoji_selected"
    case presetIconTapped = "preset_icon_tapped"
}

/// Defines all analytics parameter keys used in the application.
struct AnalyticsParameterKey {
    static let presetName = "preset_name"
    static let durationHours = "duration_hours"
    static let durationMinutes = "duration_minutes"
    static let isScheduled = "is_scheduled"
}
