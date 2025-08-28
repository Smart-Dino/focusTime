//
//  PresetGridConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 02.07.25.
//

import SwiftUI

extension FocusSessionView.Constants {
    // MARK: - Constants for FocusPresetGridView
    enum PresetGrid {
        enum Strings {
            static let title = String(
                localized: "focus_session_view_preset_grid_title",
                table: "SessionLocalizable",
                comment: "Title for the focus preset selection grid"
            )
            static let subtitle = String(
                localized: "focus_session_view_preset_grid_subtitle",
                table: "SessionLocalizable",
                comment: "Subtitle explaining preset blocklists"
            )
        }
        
        enum Layout {
            static let mainSpacing: CGFloat = 16
            static let gridHSpacing: CGFloat = 1
            static let minimumCellWidth: CGFloat = 80
            static let gridVSpacing: CGFloat = 20
            static var gridColumns: [GridItem] {
                [GridItem(.adaptive(minimum: minimumCellWidth), spacing: gridHSpacing)]
            }
        }
    }
    
    // MARK: - Constants for PresetIconView
     enum PresetIcon {
         enum Layout {
            static let mainSpacing: CGFloat = 8
            static let size: CGFloat = 60
            static let cornerRadius: CGFloat = 20
        }
    }
}
