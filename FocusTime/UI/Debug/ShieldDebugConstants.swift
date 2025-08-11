//
//  ShieldDebugConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.08.2025.
//

import SwiftUI
import DeviceActivity

extension ShieldDebugView {
    enum Constants {
        // MARK: - Strings
        enum Strings {
            static let eraseAllData = String(localized: "shield_debug_erase_all_data", table: "DebugLocalizable")
            static let statusSection = String(localized: "shield_debug_status_section", table: "DebugLocalizable")
            static let selectionSection = String(localized: "shield_debug_selection_section", table: "DebugLocalizable")
            static let blockTypePicker = String(localized: "shield_debug_block_type_picker", table: "DebugLocalizable")
            static let scheduledType = String(localized: "shield_debug_picker_scheduled", table: "DebugLocalizable")
            static let durationType = String(localized: "shield_debug_picker_duration", table: "DebugLocalizable")
            static let toggleSelectionSheet = String(localized: "shield_debug_toggle_selection_sheet", table: "DebugLocalizable")
            static let createSchedule = String(localized: "shield_debug_create_schedule", table: "DebugLocalizable")
            static let controlsSection = String(localized: "shield_debug_controls_section", table: "DebugLocalizable")
            static let startBlock = String(localized: "shield_debug_start_block", table: "DebugLocalizable")
            static let endBlock = String(localized: "shield_debug_end_block", table: "DebugLocalizable")
            static let suspend = String(localized: "shield_debug_suspend", table: "DebugLocalizable")
            static let resume = String(localized: "shield_debug_resume", table: "DebugLocalizable")
            static let blockDuration = String(localized: "shield_debug_block_duration", table: "DebugLocalizable")
            static let blockDurationSuffix = String(localized: "shield_debug_block_duration_suffix", table: "DebugLocalizable")
            static let selectStartTime = String(localized: "shield_debug_select_start_time", table: "DebugLocalizable")
            static let selectEndTime = String(localized: "shield_debug_select_end_time", table: "DebugLocalizable")
            static let appsChosen = String(localized: "shield_debug_apps_chosen", table: "DebugLocalizable")
            static let categoriesChosen = String(localized: "shield_debug_categories_chosen", table: "DebugLocalizable")
            static let blockItemIdPrefix = String(localized: "shield_debug_block_item_id_prefix", table: "DebugLocalizable")
        }

        // MARK: - Layout
        enum Layout {
            static let sectionVerticalSpacing: CGFloat = 24
            static let buttonVerticalSpacing: CGFloat = 12
            static let horizontalPadding: CGFloat = 16
        }
        
        // MARK: - ActivityConfiguration
        @MainActor
        enum ActivityConfiguration {
            static let context = DeviceActivityReport.Context.totalActivity
            static let filter = DeviceActivityFilter(
                segment: .daily(during: DateInterval(
                    start: Calendar.current.startOfDay(for: .now),
                    duration: 86400)),
                users: .all,
                devices: .init([.iPhone])
            )
        }
    }
}
