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

@MainActor
@Observable
final class LiveShieldManager: ShieldManager {
    private let store: ManagedSettingsStore
    
    var isShieldActive: Bool {
        store.shield.applications != nil
        || store.shield.applicationCategories != nil
    }
    
    init() {
        let store = ManagedSettingsStore()
        self.store = store
    }
    
    func block() async throws {
        try await checkAuthorization()
        
        store.shield.applicationCategories = .all()
    }
    
    func block(specific selection: FamilyActivitySelection) async throws {
        try await checkAuthorization()
        
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
    
    func block(specific selections: [FamilyActivitySelection]) async throws {
        try await checkAuthorization()
        
        // Add all the items to discourage.
        var applicationsToDiscourage = Set<ApplicationToken>()
        var applicationCategoriesToDiscourage = Set<ActivityCategoryToken>()
        
        for selection in selections {
            applicationsToDiscourage.formUnion(selection.applicationTokens)
            applicationCategoriesToDiscourage.formUnion(selection.categoryTokens)
        }
        
        // Block selected applications.
        if applicationsToDiscourage.isEmpty {
            store.shield.applications = nil
        } else {
            store.shield.applications = applicationsToDiscourage
        }
        
        // Block selected categories.
        if applicationCategoriesToDiscourage.isEmpty {
            store.shield.applicationCategories = nil
        } else {
            store.shield.applicationCategories = .specific(applicationCategoriesToDiscourage)
        }
    }
    
    func unblock() async throws {
        try await checkAuthorization()
        
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
    
    func checkAuthorization() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }
}
