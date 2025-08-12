//
//  DeviceActivity+Sendable.swift
//  FocusTime
//
//  Created by Maksym Horobets on 12.08.2025.
//

import Foundation
import DeviceActivity

// This is just an enum for a String rawValue so whatever.
extension DeviceActivityName: @retroactive @unchecked Sendable { }

// This is just a struct holding two DateComponents so whatever.
extension DeviceActivitySchedule: @retroactive @unchecked Sendable { }
