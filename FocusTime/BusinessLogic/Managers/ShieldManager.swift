//
//  BlockManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 24.06.2025.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

@MainActor
protocol ShieldManager {
    // MARK: - Properties
    var isShieldActive: Bool { get }
    // MARK: - Block
    func block() async throws
    func block(specific selection: FamilyActivitySelection) async throws
    func block(specific selection: FamilyActivitySelection, start: Date, finish: Date, repeats: Bool) async throws
    // MARK: - Unblock
    func unblock() async throws
    // MARK: - Auth
    func checkAuthorization() async throws
}

@MainActor
@Observable
final class LiveShieldManager: ShieldManager {
    private let store: ManagedSettingsStore
    private let center: DeviceActivityCenter
    private(set) var isShieldActive: Bool = false
    
    init() {
        let store = ManagedSettingsStore()
        let center = DeviceActivityCenter()
        self.store = store
        self.center = center
        updateShieldStatus()
    }
    
    func block() async throws {
        try await checkAuthorization()
        defer { updateShieldStatus() }
        
        store.shield.applicationCategories = .all()
    }
    
    func block(specific selection: FamilyActivitySelection) async throws {
        try await checkAuthorization()
        defer { updateShieldStatus() }
        
        let applicationsToDiscourage = selection.applicationTokens
        
        // Block selected applications.
        if applicationsToDiscourage.isEmpty {
            store.shield.applications = nil
        } else {
            store.shield.applications = applicationsToDiscourage
        }
        
        let applicationCategoriesToDiscourage = selection.categoryTokens
        
        // Block selected categories.
        if applicationCategoriesToDiscourage.isEmpty {
            store.shield.applicationCategories = nil
        } else {
            store.shield.applicationCategories = .specific(applicationCategoriesToDiscourage)
        }
    }
    
//    func block(specific selection: FamilyActivitySelection, start: Date, finish: Date, repeats: Bool) async throws {
//        let deviceActivitySchedule = DeviceActivitySchedule(intervalStart: <#T##DateComponents#>,
//                                                            intervalEnd: <#T##DateComponents#>,
//                                                            repeats: <#T##Bool#>)
//    }
    
    func unblock() async throws {
        try await checkAuthorization()
        defer { updateShieldStatus() }
        
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
    
    func updateShieldStatus() {
        isShieldActive = store.shield.applications != nil || store.shield.applicationCategories != nil
    }
    
    func checkAuthorization() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }
}
