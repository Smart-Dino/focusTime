//
//  FreePlanUpgradeConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.05.2025.
//

import Foundation

/// Organized and sorted ``FreePlanUpgradeView``-related constants.
enum FreePlanUpgradeConstants {
    // MARK: - FreeplanUpgrade Layout
    enum Spacings {
        static let offerView: CGFloat = 15
    }
    // MARK: - FreeplanUpgrade Strings
    enum Strings {
        /// Body message of the upgrade view.
        static var upgradeMessage: AttributedString {
            var string = AttributedString("Upgrade to have unlimited scheduled\nsessions with Pro version")
            if let range = string.range(of: "Pro version") {
                string[range].font = .body.bold()
            }
            return string
        }
        /// Title of the view.
        static let title = "You're on a Free Plan"
        // Buttons
        static let tryButtonTitle = "Try For $0,00"
        static let viewPlansButton = "View All Plans"
        static let dismissButtonTitle = "Dismiss current screen."
    }
}
