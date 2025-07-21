//
//  HomeViewConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 16.06.2025.
//

import SwiftUI

extension HomeView {
    enum Constants {
        // MARK: - Strings
        enum Strings {
            static let navigationTitle = "Let's make your\nconcentration better"
            static let timerValue = "1h 36m 50s"
            static let timerSubtitle = "Screen time today"
            static let scheduledFocusTitle = "Scheduled Focus"
            static let scheduledFocusSubtitle = "Take control with a scheduled session"
            static let bottomButtonTitle = "Start Focusing"
        }

        // MARK: - Icons
        enum Icons {
            static let waveImage = ImageResource.MainImages.homeViewWave
            static let chevronRight = "chevron.right"
            static let hourglass = "hourglass"
        }

        // MARK: - Typography
        enum Fonts {
            static let navigationTitle = SharedConstants.Fonts.navigationTitle
        }

        // MARK: - Layout
        enum Layout {
            static let mainSpacing: CGFloat = 70
        }
    }
}
