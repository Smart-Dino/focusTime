//
//  ProtectedModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 03.07.2025.
//

import SwiftData
import Foundation

protocol ProtectedModel: Sendable, Identifiable {
    associatedtype Model: PersistentModel
    var persistentModelID: PersistentIdentifier? { get }
    
    init(from item: Model)
}

extension ProtectedModel {
    var id: Int { persistentModelID?.id.hashValue ?? UUID().hashValue }
}
