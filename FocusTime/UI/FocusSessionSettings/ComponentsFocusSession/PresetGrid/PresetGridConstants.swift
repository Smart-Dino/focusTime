//
//  PresetGridConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 02.07.25.
//

import SwiftUI
import FocusTimeUI 

extension FocusSessionView.Constants {
    // MARK: - Constants for FocusPresetGridView
    public enum PresetGrid {
        public enum Strings {
            public static let title = "Choose Your Focus Preset"
            public static let subtitle = "Ready-made blocklists to help you stay focused. Choose a preset to quickly block distracting apps."
        }
        
        public enum Layout {
            public static let mainSpacing: CGFloat = 16
            private static let gridHSpacing: CGFloat = 20
            private static let minimumCellWidth: CGFloat = 80
            public static let gridVSpacing: CGFloat = 20
            public static var gridColumns: [GridItem] { [GridItem(.adaptive(minimum: minimumCellWidth), spacing: gridHSpacing)] }
        }
    }
    
    // MARK: - Constants for PresetIconView
    public enum PresetIcon {
        public enum Layout {
            public static let mainSpacing: CGFloat = 8
            public static let size: CGFloat = 60
            public static let cornerRadius: CGFloat = 20
        }
    }
}
