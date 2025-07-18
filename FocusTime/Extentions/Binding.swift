//
//  Binding.swift
//  FocusTime
//
//  Created by George Kyrylenko on 18.07.2025.
//

import SwiftUI

extension Binding {
    @MainActor
    static func binding<T: Sendable>(get value: T, set: @MainActor @Sendable @escaping (_: T) -> ()) -> Binding<T> {
        .init(get: { value }, set: { val in set(val) })
    }
    
    @MainActor
    static func binding<T: Sendable>(get value: T?, set: @MainActor @Sendable @escaping (_: T?) -> ()) -> Binding<T>? {
        guard let value else {
            return nil
        }
        return .init(get: { value }, set: { val in set(val) })
    }
}
