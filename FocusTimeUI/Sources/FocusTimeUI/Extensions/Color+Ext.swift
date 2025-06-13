//
//  Color+Ext.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 26.05.2025.
//

import SwiftUI

public extension ShapeStyle where Self == Color {
    static var ftBackground: Color { Color("CustomBackground", bundle: .module) }
    static var ftPageControlBlue: Color { Color("PageControlBlue", bundle: .module) }
}
