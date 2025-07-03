//
//  ScheduleConfigurationConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 03.07.25.
//

import SwiftUI

extension FocusSessionView.Constants {
    // MARK: - Constants for ScheduleConfigurationView
    public enum Configuration {
        public enum Strings {
            public static let listName = "List name"
            public static let listNamePlaceholder = "Name"
            public static let scheduleForLater = "Schedule for later"
            public static let scheduleInfo = "Turn on to have this blocklist activate automatically based on your scheduled days and times."
            public static let duration = "Duration"
            public static let appsBlocked = "Apps Blocked"
            public static let appsBlockedList = "List"
            public static let appListPickerDestination = "App List Picker Screen"
            public static let scheduledDays = "Scheduled Days"
            public static let startTime = "Start time"
            public static let letEndTime = "End time"
        }
        
        public enum Layout {
            public static let mainSpacing: CGFloat = 16
            public static let scheduleSectionSpacing: CGFloat = 8
            public static let scheduleInfoHorizontalPadding: CGFloat = 4
            public static let listIconSpacing: CGFloat = 12
            public static let selectedIconSize: CGFloat = 36
        }
        
        public enum Colors {
            public static let toggleTint = Color.green
        }
    }
}
