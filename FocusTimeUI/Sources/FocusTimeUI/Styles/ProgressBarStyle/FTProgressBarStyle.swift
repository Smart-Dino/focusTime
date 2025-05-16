//
//  FTProgressBarStyle.swift
//  FocusTimeUI
//
//  Created by Keto Nioradze on 16.05.25.
//

import SwiftUI

// MARK: - FTProgressBarStyle

/// A progress bar view partitioned into four segments.
/// Highlights the current active segment and shows others as inactive.
public struct FTProgressBarStyle: View {
    
    /// The current active step (1-based index) to highlight.
    public var currentStep: Int
    
    /// Initialises the progress bar with the current step.
    /// - Parameter currentStep: The active segment index from 1 to 4.
    public init(currentStep: Int) {
        self.currentStep = currentStep
    }
    
    // MARK: - Colors
    
    /// Color used for the active segment.
    private let activeColor = Color.blue
    
    /// Color used for inactive segments.
    private let inactiveColor = Color.gray.opacity(0.3)
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 8) {
            ForEach(1...4, id: \.self) { index in
                Rectangle()
                    .fill(index == currentStep ? activeColor : inactiveColor)
                    .frame(height: 6)
                    .cornerRadius(3)
            }
        }
    }
}
