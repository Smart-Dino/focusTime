//
//  SplashScreenDelegate.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.08.2025.
//

import Foundation

@MainActor
protocol SplashScreenDelegate: AnyObject {
    func didFinishInitWithError(_ error: Error)
}
