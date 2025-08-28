//
//  String+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 25.08.2025.
//

import Foundation

extension String {
    func filterToFirstEmoji() -> String {
        String(self.filter({ $0.isEmoji }).prefix(1))
    }
}
