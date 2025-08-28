//
//  DeviceActivityRegistrar.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//

import Foundation

protocol DeviceActivityRegistrar: Actor {
    func registerActivity(during blockItem: ProtectedBlockItem) async throws
    func unregisterActivity(during blockItem: ProtectedBlockItem) async throws
    
    func suspendActivity(for blockItem: ProtectedBlockItem) async throws
    func suspendActivity(for blockItem: ProtectedBlockItem, forSeconds seconds: Int) async throws
    
    func resumeActivity(for blockItem: ProtectedBlockItem) async throws
    func cancelScheduledResume(for blockItem: ProtectedBlockItem) async throws
    
    func isActivityRegistered(for blockItem: ProtectedBlockItem) async throws -> Bool
    func cancelIfRunning(_ blockItem: ProtectedBlockItem) async throws
    
    func unregisterAll() async
}
