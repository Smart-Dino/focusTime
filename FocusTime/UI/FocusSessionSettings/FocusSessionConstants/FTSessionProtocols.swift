//
//  FTSessionProtocols.swift
//  FocusTime
//
//  Created by Keto Nioradze on 17.06.25.
//

import Foundation

@MainActor
protocol SessionConfigurationViewDelegate: AnyObject {
    func sessionConfigurationDidUpdateListName(to newName: String)
    func sessionConfigurationDidUpdateScheduleToggle(to newValue: Bool)
    func sessionConfigurationDidTapDuration()
    func sessionConfigurationDidToggleDay(_ day: Weekday)
    func sessionConfigurationDidTapStartTime()
    func sessionConfigurationDidTapEndTime()
    func sessionConfigurationDidTapAppsBlocked()
}

@MainActor
protocol FocusPresetGridViewDelegate: AnyObject {
    func focusPresetGridDidSelectPreset(_ preset: FocusPreset)
}

@MainActor
protocol DurationPickerSheetViewDelegate: AnyObject {
    func durationPickerDidSave(hours: Int, minutes: Int)
}

@MainActor
protocol TimePickerSheetViewDelegate: AnyObject {
    func timePickerDidSave(date: Date, type: TimePickerType)
}
