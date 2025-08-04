//
//  FocusTimeActivityReport.swift
//  FocusTimeActivityReport
//
//  Created by Maksym Horobets on 24.07.2025.
//

import SwiftUI
import ExtensionKit
import DeviceActivity

@main
struct FocusTimeActivityReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
