//
//  LiveDeviceActivityRegistrar+Helpers.swift
//  FocusTime
//
//  Created by Maksym Horobets on 28.07.2025.
//

import Foundation
import DeviceActivity

extension LiveDeviceActivityRegistrar {
    func getActivityForSchedule(_ blockItem: ProtectedBlockItem) async throws -> DeviceActivityName {
        guard let activityName = await centerManager.activities
            .first(where: { name in
                CodableActivityIdentifier(from: name)?.blockItemID == blockItem.id
            })
        else {
            throw DeviceActivityRegistrarError.activityNotFound
        }
        
        return activityName
    }
}

