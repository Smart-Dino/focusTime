//
//  SafeSharedValue.swift
//  FocusTime
//
//  Created by Maksym Horobets on 11.06.2025.
//

import Foundation

@propertyWrapper struct SafeSharedValue <T: AnyObject> {
  private let factory: () -> T
  weak var optionalValue: T?
  var valueQueue = DispatchQueue(label: "SafeSharedValue.valueQueue.\(UUID().uuidString)")
  var wrappedValue: T {
    mutating get {
      valueQueue.sync {
        if let optionalValue {
          return optionalValue
        } else {
          let value = factory()
          optionalValue = value
          return value
        }
      }
    }
    set {
      optionalValue = newValue
    }
  }
  init(factory: @escaping () -> T,
     optionalValue: T? = nil) {
    self.factory = factory
    self.optionalValue = optionalValue
  }
}
