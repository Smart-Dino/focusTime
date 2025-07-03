//
//  SessionSettingConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import Foundation
import SwiftUI

extension FocusSessionView {
    
    public enum Constants { // MARK: - Made public
        
        // MARK: - Private Shared Constants
        private static let pickerSheetContainerHeight: CGFloat = 213
        private static let pickerSheetContainerCornerRadius: CGFloat = 13
        private static let pickerSheetMainVStackSpacing: CGFloat = 16
        private static let pickerSheetDragIndicatorWidth: CGFloat = 40
        private static let pickerSheetDragIndicatorHeight: CGFloat = 5
        private static let pickerSheetPickerBackground = Color(.darkGray).opacity(0.1)
        
        // MARK: - General Strings
        public enum Strings { // MARK: - Made public
            public static let navigationTitle = "Focus Setup"
            public static let startButtonTitle = "Start"
        }
        
        // MARK: - General Layout
        public enum Layout { // MARK: - Made public
            public static let mainVStackSpacing: CGFloat = 40
            public static let sheetHeight: CGFloat = 400
            public static let sheetCornerRadius: CGFloat = 25
            public static let floatingButtonBottomPadding: CGFloat = 20
            public static let floatingButtonHorizontalPadding: CGFloat = 20
        }
        
        // MARK: - General Colors
        public enum Colors { // MARK: - Made public
            public static let background = Color(red: 0.07, green: 0.09, blue: 0.11)
            public static let navigationBarBackground = Color(red: 0.07, green: 0.09, blue: 0.11)
            public static let sheetBackground = Color(red: 0.1, green: 0.1, blue: 0.12)
            public static let chevronColor = Color.blue
        }
        
        // MARK: - Symbols
        public enum Symbols { // MARK: - Made public
            public static let startButtonIcon = "hourglass"
            public static let navigationChevron = "chevron.right"
        }
        
        
        // MARK: - Default Values for ViewModel
        public enum DefaultValues { // MARK: - Made public
            public static let listName = "Focus Session"
            public static let durationHours = 0
            public static let durationMinutes = 30
            public static let startTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            public static let endTime: Date = Calendar.current.date(from: DateComponents(hour: 17, minute: 0))!
        }
        
        
        // MARK: - Static Data
        public enum Data { // MARK: - Made public
            @MainActor public static let presets: [FocusPreset] = FocusPreset.allCases
        }
        
        // MARK: - Time Related
        public enum Time { // MARK: - Made public
            public static let hoursInDay = 24
            public static let minutesInHour = 60
            public static let hourSuffix = "h"
            public static let minuteSuffix = "m"
        }
        
        // MARK: - Constants for RowStyle
        public enum Row { // MARK: - Made public
            public static let height: CGFloat = 64
            public static let cornerRadius: CGFloat = 12
            public static let background = Color(hex: "#2C2C2E")
        }
        
        // MARK: - Constants for SessionConfigurationView
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
        
        // MARK: - Constants for FocusPresetGridView
        public enum PresetGrid { // MARK: - Made public
            public enum Strings { // MARK: - Made public
                public static let title = "Choose Your Focus Preset"
                public static let subtitle = "Ready-made blocklists to help you stay focused. Choose a preset to quickly block distracting apps."
            }
            
            public enum Layout { // MARK: - Made public
                public static let mainSpacing: CGFloat = 16
                private static let gridHSpacing: CGFloat = 20
                private static let minimumCellWidth: CGFloat = 80
                public static let gridVSpacing: CGFloat = 20
                public static var gridColumns: [GridItem] { [GridItem(.adaptive(minimum: minimumCellWidth), spacing: gridHSpacing)] }
            }
        }
        
        // MARK: - Constants for PresetIconView
        public enum PresetIcon { // MARK: - Made public
            public enum Layout { // MARK: - Made public
                public static let mainSpacing: CGFloat = 8
                public static let size: CGFloat = 60
                public static let cornerRadius: CGFloat = 20
            }
            
            public enum Colors { // MARK: - Made public
                public static let background = Color(hex: "#2C2C2E")
                public static let selectedBackground = Color(hex: "#273D6F")
                public static let selectedBorder = Color.blue
            }
        }
        
        // MARK: - Constants for DurationPickerSheetView
        public enum DurationPicker { // MARK: - Made public
            public enum Strings { // MARK: - Made public
                public static let title = "Session Length"
                public static let subtitle = "Choose how long you want to stay focused"
                public static let hoursPickerTitle = "Hours"
                public static let minutesPickerTitle = "Minutes"
            }
            
            public enum Layout { // MARK: - Made public
                public static let mainSpacing = Constants.pickerSheetMainVStackSpacing
                public static let dragIndicatorWidth = Constants.pickerSheetDragIndicatorWidth
                public static let dragIndicatorHeight = Constants.pickerSheetDragIndicatorHeight
                public static let containerWidth: CGFloat = 139
                public static let containerHeight = Constants.pickerSheetContainerHeight
                public static let containerCornerRadius = Constants.pickerSheetContainerCornerRadius
                public static let pickerWidth: CGFloat = 70
            }
            
            public enum Colors { // MARK: - Made public
                public static let pickerBackground = Constants.pickerSheetPickerBackground
            }
        }
        
        // MARK: - Constants for TimePickerSheetView
        public enum TimePicker { // MARK: - Made public
            public enum Strings { // MARK: - Made public
                public static let startTimeTitle = "Start Time"
                public static let startTimeSubtitle = "Choose when the session starts"
                public static let endTimeTitle = "End Time"
                public static let endTimeSubtitle = "Choose when the session ends"
                public static let hoursPickerTitle = "Hours"
                public static let minutesPickerTitle = "Minutes"
            }
            public enum Layout { // MARK: - Made public
                public static let mainSpacing = Constants.pickerSheetMainVStackSpacing
                public static let dragIndicatorWidth = Constants.pickerSheetDragIndicatorWidth
                public static let dragIndicatorHeight = Constants.pickerSheetDragIndicatorHeight
                public static let containerWidth: CGFloat = 250
                public static let containerHeight = Constants.pickerSheetContainerHeight
                public static let containerCornerRadius = Constants.pickerSheetContainerCornerRadius
                public static let pickerWidth: CGFloat = 125
            }
            public enum Colors { // MARK: - Made public
                public static let pickerBackground = Constants.pickerSheetPickerBackground
            }
        }
        
        // MARK: - Constants for DaysPickerPopup
        enum DaysPickerPopup {
            enum Layout {
                static let itemSpacing: CGFloat = 12
                static let verticalPadding: CGFloat = 12
                static let cornerRadius: CGFloat = 12
                static let shadowRadius: CGFloat = 10
                static let shadowY: CGFloat = 5
            }
            enum Colors {
                static let divider = Color.white.opacity(0.15)
                static let background = Color(red: 0.2, green: 0.2, blue: 0.22)
                static let shadow = Color.black.opacity(0.3)
            }
            enum Symbols {
                static let checkmark = "checkmark"
            }
        }
        
        // MARK: - Constants for GradientBackgroundView
        enum Gradient {
            enum Colors {
                static let backgroundDeep = Color(hex: "#000C10")
                static let gradientTop = Color(hex: "#0E4D76")
                static let gradientBottom = Color(hex: "#9D71FE")
            }
            enum Layout {
                static let gradientOpacity: CGFloat = 0.3
                static let blurRadius: CGFloat = 100
                static let topCircleWidth: CGFloat = 612
                static let topCircleHeight: CGFloat = 394
                static let topCircleOffsetY: CGFloat = -150
                static let bottomCircleWidth: CGFloat = 412
                static let bottomCircleHeight: CGFloat = 323
                static let bottomCircleOffsetY: CGFloat = 170
            }
        }
    }
}
