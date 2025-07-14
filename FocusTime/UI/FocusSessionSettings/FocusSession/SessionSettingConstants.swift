//
//  SessionSettingConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import SwiftUI

extension FocusSessionView {
    
    public enum Constants {
        // MARK: - General Strings
        public enum Strings { 
            public static let navigationTitle = "Focus Setup"
            public static let startButtonTitle = "Start"
            public static let durationPickerSheetErrorTitle = "Error: DurationPickerSheetViewModel not initialized."
        }
        
        // MARK: - General Layout
        public enum Layout {
            public static let mainVStackSpacing: CGFloat = 40
            public static let sheetHeight: CGFloat = 400
            public static let sheetCornerRadius: CGFloat = 25
            public static let floatingButtonHorizontalPadding: CGFloat = 20
        }
        
        // MARK: - General Colors
        public enum Colors {
            public static let chevronColor = Color.blue
        }
        
        // MARK: - Symbols
        public enum Symbols {
            public static let startButtonIcon = "hourglass"
            public static let navigationChevron = "chevron.right"
        }
        
        
        // MARK: - Default Values for ViewModel
        public enum DefaultValues {
            public static let listName = "Focus Session"
            public static let durationHours = 0
            public static let durationMinutes = 30
            public static let startTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            public static let endTime: Date = Calendar.current.date(from: DateComponents(hour: 17, minute: 0))!
        }
    }
}
