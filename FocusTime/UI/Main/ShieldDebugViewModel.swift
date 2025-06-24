//
//  ShieldDebugViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 24.06.2025.
//

import Foundation
import FamilyControls

@MainActor
@Observable
final class ShieldDebugViewModel {
    // MARK: - Nested declarations
    @MainActor
    struct State {
        var error: Error? = nil
        
        var selection: FamilyActivitySelection = .init()
        var isAppSelectionPresented = false
    }
    
    // MARK: - Properties
    private(set) var state: State
    let shieldManager = LiveShieldManager()
    
    // MARK: - Initializer
    init(state: State = State()) {
        self.state = state
    }
    
    // MARK: - Setters
    func setAppSelectionPresented(_ isPresented: Bool) {
        state.isAppSelectionPresented = isPresented
    }
    
    func setSelection(_ selection: FamilyActivitySelection) {
        state.selection = selection
    }
    
    // MARK: - Methods
    func blockSelection() async {
        do {
            try await shieldManager.block(specific: state.selection)
        } catch {
            state.error = error
        }
    }
    
    func unblockSelection() async {
        do {
            try await shieldManager.unblock()
        } catch {
            state.error = error
        }
    }
    
    func toggleSelectionSheet() async {
        do {
            try await shieldManager.checkAuthorization()
            state.isAppSelectionPresented.toggle()
        } catch {
            state.error = error
        }
    }
}
