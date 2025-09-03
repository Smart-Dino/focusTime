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

actor LiveShieldManager: ShieldManager {
    let isRunningInExtension: Bool
    let store = ManagedSettingsStore()
    
    init(isRunningInExtension: Bool = false) {
        self.isRunningInExtension = isRunningInExtension
    }
    
    var isShieldActive: Bool {
        get async throws {
            try await checkAuthorization()
            return store.shield.applications != nil
            || store.shield.applicationCategories != nil
        }
    }
    
    func block() async throws {
        try await checkAuthorization()
        
        store.shield.applicationCategories = .all()
    }
    
    func block(specific selection: FamilyActivitySelection) async throws {
        try await checkAuthorization()
        
        guard !selection.isEmpty else {
            try await block()
            return
        }
        
        // Block selected applications.
        store.shield.applications = selection.applicationTokens
        
        // Block selected categories.
        store.shield.applicationCategories = .specific(selection.categoryTokens)
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
        
        guard !applicationsToDiscourage.isEmpty || !applicationsToDiscourage.isEmpty else {
            try await block()
            return
        }
        
        // Block selected applications.
        store.shield.applications = applicationsToDiscourage
        
        // Block selected categories.
        store.shield.applicationCategories = .specific(applicationCategoriesToDiscourage)
    }
    
    func unblock() async throws {
        try await checkAuthorization()
        
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
    
    func checkAuthorization() async throws {
        if !isRunningInExtension {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        }
    }
}
