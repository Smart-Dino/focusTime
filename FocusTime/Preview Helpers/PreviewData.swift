//
//  PreviewData.swift
//  FocusTime
//
//  Created by Maksym Horobets on 04.07.2025.
//
//  A centralized collection of mock objects and services for use in SwiftUI Previews.
//  This avoids repetitive setup code in preview blocks and ensures consistency.
//

import SwiftData
import Foundation
import FamilyControls

@MainActor
enum PreviewData {

    // MARK: - High-Level Mocks & Factories
    
    /// A mock factory for creating payment managers.
    static let mockPaymentManagerFactory = MockPaymentManagerFactory()
    
    /// A mock factory for creating persistence stores.
    static let mockPersistenceStoreFactory = MockPersistenceStoreFactory()
    
    /// A live implementation of the defaults manager for previews that need it.
    static let mockDefaultsManager = LiveDefaultsManager()

    // MARK: - Payment & Pro State Mocks
    
    /// A generic payment manager mock that returns errors on purchase.
    static let mockPaymentManager = MockPaymentManagerWithPurchaseError()
    static let mockProState = mockPaymentManager.state

    /// A payment manager mock specifically configured for when a user has **not** used their trial.
    static let mockPaymentManagerTrialUnused = MockPaymentManagerWithPurchaseError(trialUsed: false)
    static let mockProStateTrialUnused = mockPaymentManagerTrialUnused.state

    /// A payment manager mock specifically configured for when a user **has** already used their trial.
    static let mockPaymentManagerTrialUsed = MockPaymentManagerWithPurchaseError(trialUsed: true)
    static let mockProStateTrialUsed = mockPaymentManagerTrialUsed.state

    // MARK: - General Utility Mocks

    /// A presenter for displaying paywall views.
    static let mockPaywallPresenter = LivePaywallPresenter()
    
    /// A reusable, controllable timer for views that display countdowns or time-based events.
    static let mockTimer = ConcurrencyTimer()

    // MARK: - SwiftData Containers (Private)

    /// An empty, in-memory model container for a clean data state.
    /// Ideal for previews of creation or editing views.
    private static let inMemoryContainer: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            return try ModelContainer(for: BlockItem.self, configurations: configuration)
        } catch {
            fatalError("Failed to create in-memory ModelContainer: \(error)")
        }
    }()

    /// A pre-populated, in-memory model container.
    /// Ideal for previews of views that display lists of data.
    private static let populatedInMemoryContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: BlockItem.self, configurations: config)
            let context = ModelContext(container)
            
            for i in 0..<20 {
                let blockItem = BlockItem(
                    name: "Test Item \(i + 1)",
                    emoji: SharedConstants.Strings.defaultEmojis.randomElement()!,
                    days: Weekday.weekdays,
                    type: .duration(duration: .init(seconds: .random(in: 600...7200))),
                    blockedContent: FamilyActivitySelection()
                )
                context.insert(blockItem)
            }
            
            try context.save()
            return container
        } catch {
            fatalError("Failed to create and populate in-memory ModelContainer: \(error)")
        }
    }()

    // MARK: - Empty Data Services
    
    /// A store backed by the empty in-memory container.
    static let memoryOnlyBlockItemStore = BlockItemStore(modelContainer: inMemoryContainer)
    
    /// A persistence manager that will initially find no data.
    static let mockEmptyPersistenceManager: BlockItemPersistenceManager = LiveBlockItemPersistenceManager(
        blockItemStore: memoryOnlyBlockItemStore,
        deviceActivityCenterManager: LiveDeviceActivityCenterManager()
    )
    
    /// A registrar configured with an empty persistence manager.
    static let mockEmptyActivityRegistrar: DeviceActivityRegistrar = LiveDeviceActivityRegistrar(
        blockItemPersistenceManager: mockEmptyPersistenceManager,
        shieldManager: LiveShieldManager()
    )
    
    // MARK: - Populated Data Services
    
    /// A store backed by the pre-populated in-memory container.
    static let populatedMemoryOnlyBlockItemStore = BlockItemStore(modelContainer: populatedInMemoryContainer)

    /// A persistence manager that will find pre-populated mock data on launch.
    static let mockPopulatedPersistenceManager: BlockItemPersistenceManager = LiveBlockItemPersistenceManager(
        blockItemStore: populatedMemoryOnlyBlockItemStore,
        deviceActivityCenterManager: LiveDeviceActivityCenterManager()
    )
    
    /// A registrar configured with a populated persistence manager.
    static let mockPopulatedActivityRegistrar: DeviceActivityRegistrar = LiveDeviceActivityRegistrar(
        blockItemPersistenceManager: mockPopulatedPersistenceManager,
        shieldManager: LiveShieldManager()
    )
}
