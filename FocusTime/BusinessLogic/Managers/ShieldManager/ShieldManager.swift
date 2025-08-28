//
//  BlockManager.swift
//  FocusTime
//
//  Created by Maksym Horobets on 24.06.2025.
//

import Foundation
import FamilyControls

protocol ShieldManager: Actor {
    // MARK: - Properties
    var isShieldActive: Bool { get async throws }
    // MARK: - Block
    func block() async throws
    func block(specific selection: FamilyActivitySelection) async throws
    func block(specific selections: [FamilyActivitySelection]) async throws
    // MARK: - Unblock
    func unblock() async throws
    func checkAuthorization() async throws 
}
