//
//  DeviceActivityReportContext+Ext.swift
//  FocusTimeActivityReport
//
//  Created by Maksym Horobets on 24.07.2025.
//

import SwiftUI
import DeviceActivity

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let totalActivity = Self("Total Activity")
}
