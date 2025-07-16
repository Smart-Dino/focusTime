//
//  LiveShieldManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

#warning("Sync on global actor")

struct LiveShieldManager: ShieldManager, Sendable {
    var isRunningInExtension: Bool = false
    
    var isShieldActive: Bool {
        let store = ManagedSettingsStore()
        return store.shield.applications != nil
        || store.shield.applicationCategories != nil
    }
    
    func block() async throws {
        try await checkAuthorization()
        let store = ManagedSettingsStore()
        
        store.shield.applicationCategories = .all()
    }
    
    func block(specific selection: ProtectedActivitySelection) async throws {
        try await checkAuthorization()
        let store = ManagedSettingsStore()
        let selection = selection.selection
        
        // Block selected applications.
        store.shield.applications = selection.applicationTokens
        
        // Block selected categories.
        store.shield.applicationCategories = .specific(selection.categoryTokens)
    }
    
    func block(specific selections: [ProtectedActivitySelection]) async throws {
        try await checkAuthorization()
        let store = ManagedSettingsStore()
        let selections = selections.map(\.selection)
        
        // Add all the items to discourage.
        var applicationsToDiscourage = Set<ApplicationToken>()
        var applicationCategoriesToDiscourage = Set<ActivityCategoryToken>()
        
        for selection in selections {
            applicationsToDiscourage.formUnion(selection.applicationTokens)
            applicationCategoriesToDiscourage.formUnion(selection.categoryTokens)
        }
        
        // Block selected applications.
        store.shield.applications = applicationsToDiscourage
        
        // Block selected categories.
        store.shield.applicationCategories = .specific(applicationCategoriesToDiscourage)
    }
    
    func unblock() async throws {
        try await checkAuthorization()
        let store = ManagedSettingsStore()
        
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
    
    func checkAuthorization() async throws {
        if !isRunningInExtension {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        }
    }
}
