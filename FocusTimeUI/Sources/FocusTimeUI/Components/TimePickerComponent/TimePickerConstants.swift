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
        public static let startTimeTitle = String(
            localized: "Start Time",
            table: "Localizable",
            comment: "Title for start time"
        )
        public static let startTimeSubtitle = String(
            localized: "Choose when the session starts",
            table: "Localizable",
            comment: "Title for start session subtitle"
        )
        public static let endTimeTitle = String(
            localized: "End Time",
            table: "Localizable",
            comment: "Title for end time"
        )
        public static let endTimeSubtitle = String(
            localized: "Choose when the session ends",
            table: "Localizable",
            comment: "Title for end session subtitle"
        )
    }
    
    public enum Layout {
        public static let containerHeight: CGFloat = 213
        public static let containerCornerRadius: CGFloat = 13
        public static let pickerWidthPadding: CGFloat = 100
    }
}
