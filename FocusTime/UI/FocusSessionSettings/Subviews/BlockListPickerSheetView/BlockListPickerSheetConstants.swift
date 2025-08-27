//
//  BlockListPickerSheetConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.08.2025.
//

import Foundation

extension BlockListPickerSheetView {
    enum Constants {
        enum Strings {
            // MARK: - Header
            static let title = String(
                localized: "block_list_picker_sheet_title",
                table: "SessionLocalizable"
            )
            static let subtitle = String(
                localized: "block_list_picker_sheet_subtitle",
                table: "SessionLocalizable"
            )

            // MARK: - List Titles
            static let emptyStateTitle = String(
                localized: "block_list_picker_sheet_empty_state_title",
                table: "SessionLocalizable"
            )
            static let listTitle = String(
                localized: "block_list_picker_sheet_list_title",
                table: "SessionLocalizable"
            )
            
            // MARK: - Body & Descriptions
            static let emptyStateDescription = String(
                localized: "block_list_picker_sheet_empty_state_description",
                table: "SessionLocalizable"
            )
            
            // MARK: - Buttons
            static let newBlocklistButton = String(
                localized: "block_list_picker_sheet_new_blocklist_button",
                table: "SessionLocalizable"
            )
            static let saveSelectionButton = String(
                localized: "block_list_picker_sheet_save_selection_button",
                table: "SessionLocalizable"
            )
        }
    }
}
