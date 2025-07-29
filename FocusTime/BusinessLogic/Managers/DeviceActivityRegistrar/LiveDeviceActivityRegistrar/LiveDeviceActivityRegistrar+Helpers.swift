//
//  LiveDeviceActivityRegistrar+Helpers.swift
//  FocusTime
//
//  Created by Maksym Horobets on 28.07.2025.
//

import Foundation
import DeviceActivity

extension LiveDeviceActivityRegistrar {
    func getActivityForSchedule(_ schedule: ProtectedSchedule) throws -> DeviceActivityName {
        guard let activity = center.activities.first(where: {
            if let identifier = CodableActivityIdentifier(from: $0) {
                return identifier.scheduleID == schedule.id
            } else {
                return false
            }
        }) else {
            throw DeviceActivityRegistrarError.activityNotFound
        }
        
        return activity
    }
}
