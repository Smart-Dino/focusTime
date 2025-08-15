//
//  HomeViewDelegate.swift
//  FocusTime
//
//  Created by Maksym Horobets on 01.08.2025.
//

import Foundation

@MainActor
protocol HomeViewDelegate: AnyObject {
    func didRequestPaywall()
}
