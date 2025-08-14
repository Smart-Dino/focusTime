//
//  LiveDeviceActivityRegistrar+Helpers.swift
//  FocusTime
//
//  Created by Maksym Horobets on 28.07.2025.
//

import Foundation
import DeviceActivity

extension LiveDeviceActivityRegistrar {
    func getActivityForSchedule(_ blockItem: ProtectedBlockItem) throws -> DeviceActivityName {
        guard let activity = center.activities.first(where: {
            if let identifier = CodableActivityIdentifier(from: $0) {
                return identifier.blockItemID == blockItem.id
            } else {
                return false
            }
        }) else {
            throw DeviceActivityRegistrarError.activityNotFound
        }
        
        return activity
    }
}
