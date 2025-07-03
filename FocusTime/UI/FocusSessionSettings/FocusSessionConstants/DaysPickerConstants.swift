//
//  DaysPickerConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 03.07.25.
//

import SwiftUI

extension FocusSessionView.Constants {
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
}
