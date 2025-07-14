//
//  TimePickerConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 02.07.25.
//

import SwiftUI

public enum TimePickerConstants {

    // MARK: - Constants for TimePickerSheetView
    public enum Strings {
        public static let startTimeTitle = "Start Time"
        public static let startTimeSubtitle = "Choose when the session starts"
        public static let endTimeTitle = "End Time"
        public static let endTimeSubtitle = "Choose when the session ends"
    }
    
    public enum Layout {
        public static let mainSpacing: CGFloat = 16
        public static let containerWidth: CGFloat = 250
        public static let containerHeight: CGFloat = 213
        public static let containerCornerRadius: CGFloat = 13
        public static let pickerWidth: CGFloat = 125
    }
}
