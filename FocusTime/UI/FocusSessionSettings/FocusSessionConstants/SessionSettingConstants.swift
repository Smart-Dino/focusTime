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
    }
}
