//
//  PickerSheetConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 02.07.25.
//

import SwiftUI

extension FocusSessionView.Constants {
    
    // MARK: - Private Shared Picker Sheet Constants
    private static let pickerSheetContainerHeight: CGFloat = 213
    private static let pickerSheetContainerCornerRadius: CGFloat = 13
    private static let pickerSheetMainVStackSpacing: CGFloat = 16
    private static let pickerSheetDragIndicatorWidth: CGFloat = 40
    private static let pickerSheetDragIndicatorHeight: CGFloat = 5
    private static let pickerSheetPickerBackground = Color(.darkGray).opacity(0.1)
    
    // MARK: - Constants for DurationPickerSheetView
    public enum DurationPicker {
        public enum Strings {
            public static let title = "Session Length"
            public static let subtitle = "Choose how long you want to stay focused"
            public static let hoursPickerTitle = "Hours"
            public static let minutesPickerTitle = "Minutes"
        }
        
        public enum Layout {
            public static let mainSpacing = FocusSessionView.Constants.pickerSheetMainVStackSpacing
            public static let dragIndicatorWidth = FocusSessionView.Constants.pickerSheetDragIndicatorWidth
            public static let dragIndicatorHeight = FocusSessionView.Constants.pickerSheetDragIndicatorHeight
            public static let containerWidth: CGFloat = 139
            public static let containerHeight = FocusSessionView.Constants.pickerSheetContainerHeight
            public static let containerCornerRadius = FocusSessionView.Constants.pickerSheetContainerCornerRadius
            public static let pickerWidth: CGFloat = 70
        }
        
        public enum Colors {
            public static let pickerBackground = FocusSessionView.Constants.pickerSheetPickerBackground
        }
    }
    
    // MARK: - Constants for TimePickerSheetView
    public enum TimePicker {
        public enum Strings {
            public static let startTimeTitle = "Start Time"
            public static let startTimeSubtitle = "Choose when the session starts"
            public static let endTimeTitle = "End Time"
            public static let endTimeSubtitle = "Choose when the session ends"
            public static let hoursPickerTitle = "Hours"
            public static let minutesPickerTitle = "Minutes"
        }
        public enum Layout {
            public static let mainSpacing = FocusSessionView.Constants.pickerSheetMainVStackSpacing
            public static let dragIndicatorWidth = FocusSessionView.Constants.pickerSheetDragIndicatorWidth
            public static let dragIndicatorHeight = FocusSessionView.Constants.pickerSheetDragIndicatorHeight
            public static let containerWidth: CGFloat = 250
            public static let containerHeight = FocusSessionView.Constants.pickerSheetContainerHeight
            public static let containerCornerRadius = FocusSessionView.Constants.pickerSheetContainerCornerRadius
            public static let pickerWidth: CGFloat = 125
        }
        public enum Colors {
            public static let pickerBackground = FocusSessionView.Constants.pickerSheetPickerBackground
        }
    }
}
