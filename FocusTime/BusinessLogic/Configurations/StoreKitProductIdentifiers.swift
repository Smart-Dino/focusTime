//
//  StoreKitProductIdentifiers.swift
//  FocusTime
//
//  Created by Maksym Horobets on 06.06.2025.
//

import Foundation

enum StoreKitProductIdentifiers: Equatable, CaseIterable, Identifiable {
    case trialableWeekly, monthly
    
    var id: String {
        switch self {
        case .trialableWeekly:
            "org.dino.smart.focustime.weekly"
        case .monthly:
            "org.dino.smart.focustime.monthly"
        }
    }
}
