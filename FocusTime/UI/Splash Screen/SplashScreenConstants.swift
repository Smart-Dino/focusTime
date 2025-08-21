//
//  SplashScreenConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.08.2025.
//

import SwiftUI

extension SplashScreenView {
    enum Constants {
        enum Strings {
            static let splashGreeting: String = SharedAppValues.appName ?? .init()
        }
        enum Icons {
            static let fallbackBackground: ImageResource = .FallbackImages.splashScreen
        }
    }
}
