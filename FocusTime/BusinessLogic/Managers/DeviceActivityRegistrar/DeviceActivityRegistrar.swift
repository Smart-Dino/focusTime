//
//  DeviceActivityRegistrar.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//

import Foundation

protocol DeviceActivityRegistrar: Actor {
    // MARK: - Properties
    var monitoredIdentifiers: Set<UUID> { get }
    // MARK: - Methods
    func registerActivity(during schedule: ProtectedSchedule) async throws
    func unregisterActivity(during schedule: ProtectedSchedule) async throws
    func unregisterAll()
}
