//
//  PickerSheetConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 02.07.25.
//

import SwiftUI

extension FocusSessionView.Constants {
    
    // MARK: - Constants for DurationPickerSheetView
    public enum DurationPicker {
        
        public enum Time {
            public static let hoursInDay = 24
            public static let minutesInHour = 60
        }
        
        public enum Strings {
            public static let durationPickerTitle = "Session Length"
            public static let durationPickerSubtitle = "Choose how long you want to stay focused"
            public static let hoursPickerTitle = "Hours"
            public static let minutesPickerTitle = "Minutes"
        }
        
        public enum Layout {
            public static let mainSpacing: CGFloat = 16
            public static let containerWidth: CGFloat = 139
            public static let containerHeight: CGFloat = 213
            public static let containerCornerRadius: CGFloat = 13
            public static let pickerWidth: CGFloat = 70
        }
        
        public enum Colors {
            public static let pickerBackground = Color(.darkGray).opacity(0.1)
        }
    }
}
