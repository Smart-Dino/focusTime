//
//  SessionSettingConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import Foundation
import SwiftUI

extension FocusSessionView {
    
    enum Constants {
        
        // MARK: - Private Shared Constants
        private static let pickerSheetContainerHeight: CGFloat = 213
        private static let pickerSheetContainerCornerRadius: CGFloat = 13
        private static let pickerSheetMainVStackSpacing: CGFloat = 16
        private static let pickerSheetDragIndicatorWidth: CGFloat = 40
        private static let pickerSheetDragIndicatorHeight: CGFloat = 5
        private static let pickerSheetPickerBackground = Color(.darkGray).opacity(0.1)
        
        // MARK: - General Strings
        enum Strings {
            static let navigationTitle = "Focus Setup"
            static let startButtonTitle = "Start"
        }
        
        // MARK: - General Layout
        enum Layout {
            static let mainVStackSpacing: CGFloat = 40
            static let sheetHeight: CGFloat = 400
            static let sheetCornerRadius: CGFloat = 25
        }
        
        // MARK: - General Colors
        enum Colors {
            static let background = Color(red: 0.07, green: 0.09, blue: 0.11)
            static let navigationBarBackground = Color(red: 0.07, green: 0.09, blue: 0.11)
            static let sheetBackground = Color(red: 0.1, green: 0.1, blue: 0.12)
            static let chevronColor = Color.blue // New constant for chevron color
        }
        
        // MARK: - Symbols
        enum Symbols {
            static let startButtonIcon = "hourglass"
            static let navigationChevron = "chevron.right"
        }
        
        
        // MARK: - Default Values for ViewModel
        enum DefaultValues {
            static let listName = "Focus Session"
            static let durationHours = 0
            static let durationMinutes = 30
            static let startTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            static let endTime: Date = Calendar.current.date(from: DateComponents(hour: 17, minute: 0))!
        }
        
        
        // MARK: - Static Data
        enum Data {
            static let presets: [FocusPreset] = [
                .init(name: "Morning\nRoutine", iconName: "☀️"),
                .init(name: "Social\nDetox", iconName: "📴"),
                .init(name: "Work\nSprint", iconName: "⏱️"),
                .init(name: "Zero\nDistraction", iconName: "🚫"),
                .init(name: "Study", iconName: "📚"),
                .init(name: "Creative", iconName: "🎨"),
                .init(name: "Mindfulness", iconName: "🧠"),
                .init(name: "Reading", iconName: "📖")
            ]
        }
        
        // MARK: - Time Related
        enum Time {
            static let hoursInDay = 24
            static let minutesInHour = 60
            static let hourSuffix = "h"
            static let minuteSuffix = "m"
        }
        
        // MARK: - Constants for RowStyle
        enum Row {
            static let height: CGFloat = 64
            static let cornerRadius: CGFloat = 12
            static let background = Color(hex: "#2C2C2E")
        }
        
        // MARK: - Constants for SessionConfigurationView
        enum Configuration {
            enum Strings {
                static let listName = "List name"
                static let listNamePlaceholder = "Name"
                static let scheduleForLater = "Schedule for later"
                static let scheduleInfo = "Turn on to have this blocklist activate automatically based on your scheduled days and times."
                static let duration = "Duration"
                static let appsBlocked = "Apps Blocked"
                static let appsBlockedList = "List"
                static let appListPickerDestination = "App List Picker Screen"
                static let scheduledDays = "Scheduled Days"
                static let startTime = "Start time"
                static let endTime = "End time"
            }
            
            enum Layout {
                static let mainSpacing: CGFloat = 16
                static let scheduleSectionSpacing: CGFloat = 8
                static let scheduleInfoHorizontalPadding: CGFloat = 4
                static let listIconSpacing: CGFloat = 12
                static let selectedIconSize: CGFloat = 36
                static let popupYOffset: CGFloat = 4
                static let popupAnimationDuration: TimeInterval = 0.2
                static let chevronRotationDegrees: Double = 90
            }
            
            enum Colors {
                static let toggleTint = Color.green
                static let tapCatchingBackground = Color.black.opacity(0.001)
            }
            
            enum ZIndex {
                static let backgroundDim: Double = 1
                static let popup: Double = 0.5
                static let activeRow: Double = 3
            }
        }
        
        // MARK: - Constants for FocusPresetGridView
        enum PresetGrid {
            enum Strings {
                static let title = "Choose Your Focus Preset"
                static let subtitle = "Ready-made blocklists to help you stay focused. Choose a preset to quickly block distracting apps."
            }
            
            enum Layout {
                static let mainSpacing: CGFloat = 16
                private static let gridHSpacing: CGFloat = 20
                private static let minimumCellWidth: CGFloat = 80
                static let gridVSpacing: CGFloat = 20
                static var gridColumns: [GridItem] { [GridItem(.adaptive(minimum: minimumCellWidth), spacing: gridHSpacing)] }
            }
        }
        
        // MARK: - Constants for PresetIconView
        enum PresetIcon {
            enum Layout {
                static let mainSpacing: CGFloat = 8
                static let size: CGFloat = 60
                static let cornerRadius: CGFloat = 20
                static let selectedBorderWidth: CGFloat = 2
            }
            
            enum Colors {
                static let background = Color(hex: "#2C2C2E   ")
                static let selectedBackground = Color(hex: "#273D6F")
                static let selectedBorder = Color.blue
            }
        }
        
        // MARK: - Constants for DurationPickerSheetView
        enum DurationPicker {
            enum Strings {
                static let title = "Session Length"
                static let subtitle = "Choose how long you want to stay focused"
                static let hoursPickerTitle = "Hours"
                static let minutesPickerTitle = "Minutes"
            }
            
            enum Layout {
                static let mainSpacing = Constants.pickerSheetMainVStackSpacing
                static let dragIndicatorWidth = Constants.pickerSheetDragIndicatorWidth
                static let dragIndicatorHeight = Constants.pickerSheetDragIndicatorHeight
                static let containerWidth: CGFloat = 139
                static let containerHeight = Constants.pickerSheetContainerHeight
                static let containerCornerRadius = Constants.pickerSheetContainerCornerRadius
                static let pickerWidth: CGFloat = 70
            }
            
            enum Colors {
                static let pickerBackground = Constants.pickerSheetPickerBackground
            }
        }
        
        // MARK: - Constants for TimePickerSheetView
        enum TimePicker {
            enum Strings {
                static let startTimeTitle = "Start Time"
                static let startTimeSubtitle = "Choose when the session starts"
                static let endTimeTitle = "End Time"
                static let endTimeSubtitle = "Choose when the session ends"
                static let hoursPickerTitle = "Hours"
                static let minutesPickerTitle = "Minutes"
            }
            enum Layout {
                static let mainSpacing = Constants.pickerSheetMainVStackSpacing
                static let dragIndicatorWidth = Constants.pickerSheetDragIndicatorWidth
                static let dragIndicatorHeight = Constants.pickerSheetDragIndicatorHeight
                static let containerWidth: CGFloat = 250
                static let containerHeight = Constants.pickerSheetContainerHeight
                static let containerCornerRadius = Constants.pickerSheetContainerCornerRadius
                static let pickerWidth: CGFloat = 125
            }
            enum Colors {
                static let pickerBackground = Constants.pickerSheetPickerBackground
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
