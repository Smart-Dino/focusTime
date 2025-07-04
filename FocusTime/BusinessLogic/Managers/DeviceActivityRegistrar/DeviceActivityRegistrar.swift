//
//  DeviceActivityRegistrar.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//

import Foundation

@MainActor
protocol DeviceActivityRegistrar: AnyObject {
    // MARK: - Properties
    var monitoredIdentifiers: Set<UUID> { get }
    // MARK: - Methods
    func registerActivity(during schedule: ProtectedSchedule) async throws
    func unregisterAll()
}
