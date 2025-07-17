//
//  ShieldManagerTests.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 15.07.2025.
//

import Testing
import Foundation
import FamilyControls
import ManagedSettings
@testable import FocusTime

@Suite("Tests for the ShieldManager implementations", .serialized)
struct ShieldManagerTests {
    let store: ManagedSettingsStore
    let shieldManager: ShieldManager
    
    let allCategories = ShieldSettings.ActivityCategoryPolicy<Application>.all()
    
    init() {
        self.store = ManagedSettingsStore()
        self.shieldManager = LiveShieldManager()
    }
    
    
    func resetManagedSettingsStore() async {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
        store.shield.webDomainCategories = nil
    }
    
    @Test("Basic block of all applications.")
    func blockingAllApplications() async throws {
        try await shieldManager.block()
        
        #expect(store.shield.applicationCategories == allCategories)
    }
    
    @Test("Unblocking all applications.")
    func unblockAllApplications() async throws {
        try await shieldManager.block()
        try #require(await shieldManager.isShieldActive)
        
        try await shieldManager.unblock()
        let isShieldActive = try await shieldManager.isShieldActive
        #expect(!isShieldActive && store.shield.applicationCategories == nil)
    }
    
    @Test("Block a specific ProtectedActivitySelection.")
    func blockSpecificSelection() async throws {
        var selection = FamilyActivitySelection()
        selection.applicationTokens = Set<ApplicationToken>()
        selection.categoryTokens = Set<ActivityCategoryToken>()
        let protectedSelection = ProtectedActivitySelection(selection)
        
        try await shieldManager.block(specific: protectedSelection)
        
        #expect(store.shield.applications == selection.applicationTokens)
        #expect(store.shield.applicationCategories == .specific(selection.categoryTokens))
    }
    
    @Test("Block multiple ProtectedActivitySelections.")
    func blockMultipleSelections() async throws {
        var selection1 = FamilyActivitySelection()
        selection1.applicationTokens = Set<ApplicationToken>()
        selection1.categoryTokens = Set<ActivityCategoryToken>()
        let protectedSelection1 = ProtectedActivitySelection(selection1)
        
        var selection2 = FamilyActivitySelection()
        selection2.applicationTokens = Set<ApplicationToken>()
        selection2.categoryTokens = Set<ActivityCategoryToken>()
        let protectedSelection2 = ProtectedActivitySelection(selection2)
        
        try await shieldManager.block(specific: [protectedSelection1, protectedSelection2])
        
        // Union of all tokens.
        let expectedApplications = selection1.applicationTokens.union(selection2.applicationTokens)
        let expectedCategories = selection1.categoryTokens.union(selection2.categoryTokens)
        
        #expect(store.shield.applications == expectedApplications)
        #expect(store.shield.applicationCategories == .specific(expectedCategories))
    }
    
    @Test("Unblock is idempotent.")
    func unblockIsIdempotent() async throws {
        try await shieldManager.unblock()
        try await shieldManager.unblock()
        
        #expect(try await !shieldManager.isShieldActive)
        #expect(store.shield.applications == nil && store.shield.applicationCategories == nil)
    }
    
    @Test("Check authorization does not throw.")
    func checkAuthorizationDoesNotThrow() async throws {
        try await shieldManager.checkAuthorization()
        // If it doesn't throw, the test passes.
        #expect(true)
    }
    
    @Test("isShieldActive transitions as expected.")
    func isShieldActiveTransitions() async throws {
        try await shieldManager.unblock()
        #expect(try await !shieldManager.isShieldActive)
        
        try await shieldManager.block()
        #expect(try await shieldManager.isShieldActive)
        
        try await shieldManager.unblock()
        #expect(try await !shieldManager.isShieldActive)
    }
    
}
