//
//  PaywallFeatureItem.swift
//  FocusTime
//
//  Created by Maksym Horobets on 16.05.2025.
//

import Foundation

/// Identifiable item used to list out app's features.
struct PaywallFeatureItem: Identifiable {
    let id = UUID()
    let title: String
}
