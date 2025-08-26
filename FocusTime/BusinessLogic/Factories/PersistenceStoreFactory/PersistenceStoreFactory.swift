//
//  PersistenceStoreFactory.swift
//  FocusTime
//
//  Created by Maksym Horobets on 08.08.2025.
//

import SwiftData
import Foundation

protocol PersistenceStoreFactory: Actor {
    func makeBlockItemStore() -> BlockItemStore
}
