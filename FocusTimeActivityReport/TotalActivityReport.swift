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
        
        // This is Apple's code with sendability issues.
//        let totalActivityDuration = await data.flatMap { $0.activitySegments }.reduce(0, {
//            $0 + $1.totalActivityDuration
//        })
        
        
        let segments = data.map(\.activitySegments)
        var totalActivityDuration: Double = .zero

        for await activityGroup in segments {
            let groupTotal = await activityGroup.reduce(0) { $0 + $1.totalActivityDuration }
            totalActivityDuration += groupTotal
        }
        
        return formatter.string(from: totalActivityDuration) ?? "No activity data"
    }
}
