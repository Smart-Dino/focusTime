//
//  DeviceActivityHandlerTests.swift
//  FocusTimeTests
//
//  Created by Maksym Horobets on 15.07.2025.
//

import Testing
import Foundation
import FamilyControls
import ManagedSettings
@testable import FocusTime

@Suite("Tests related to DeviceActivityHandler", .serialized)
struct DeviceActivityHandlerTests {
    let store: ManagedSettingsStore
    let handler: DeviceActivityHandler
    
    init() {
        self.store = ManagedSettingsStore()
        self.handler = DeviceActivityHandler(container: PreviewData.memoryOnlyModelContainer,
                                             shieldManager: LiveShieldManager())
        resetManagedSettingsStore()
    }
    
    func resetManagedSettingsStore() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
        store.shield.webDomainCategories = nil
    }
}
