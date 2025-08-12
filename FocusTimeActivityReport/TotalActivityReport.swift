//
//  TotalActivityReport.swift
//  FocusTimeActivityReport
//
//  Created by Maksym Horobets on 24.07.2025.
//

import SwiftUI
import ExtensionKit
import DeviceActivity

nonisolated struct TotalActivityReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .totalActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: (String) -> TotalActivityView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> String {
        // Reformat the data into a configuration that can be used to create
        // the report's view.
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        
        var totalActivityDuration: TimeInterval = 0
        for await result in data {
            for await segment in result.activitySegments {
                totalActivityDuration += segment.totalActivityDuration
            }
        }
        
        return formatter.string(from: totalActivityDuration) ?? "No activity data"
    }
}
