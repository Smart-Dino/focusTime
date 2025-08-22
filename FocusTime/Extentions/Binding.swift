//
//  Binding.swift
//  FocusTime
//
//  Created by George Kyrylenko on 18.07.2025.
//

import SwiftUI

extension Binding {
    /// Creates a `Binding` for a non-optional value using the provided getter value and asynchronous setter closure.
    /// - Parameters:
    ///   - value: The current value to be used as the binding's getter.
    ///   - set: An asynchronous closure invoked with the new value when the binding is updated.
    /// - Returns: A `Binding` instance reflecting the provided value and setter.
    @MainActor
    static func binding<T: Sendable>(get value: T, set: @MainActor @Sendable @escaping (_: T) -> ()) -> Binding<T> {
        .init(get: { value }, set: { val in set(val) })
    }
    
    /// Creates an optional `Binding` for a value of type `T` if the provided value is non-nil.
    /// - Parameters:
    ///   - value: The optional value to bind. If `nil`, the method returns `nil`.
    ///   - set: An asynchronous closure called when the binding's value changes.
    /// - Returns: A `Binding<T>` if `value` is non-nil; otherwise, `nil`.
    @MainActor
    static func binding<T: Sendable>(get value: T?, set: @MainActor @Sendable @escaping (_: T?) -> ()) -> Binding<T>? {
        guard let value else {
            return nil
        }
        return .init(get: { value }, set: { val in set(val) })
    }
}
