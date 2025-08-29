//
//  TempMode.swift
//  FocusTime
//
//  Created by Maksym Horobets on 29.08.2025.
//

import Foundation

enum TempMode: Codable, Equatable, Hashable {
    case oneTimeBlock
    case relatedTo(blockID: UUID)
}
