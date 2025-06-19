//
//  AppBlockingListConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import Foundation
import SwiftUI

extension AppBlockingListView {
    enum Constants {
        // MARK: - Typography
        enum Fonts {
            static let navigationTitle = SharedConstants.Fonts.navigationTitle
        }

        // MARK: - Strings
        enum Strings {
            static let navTitle = "App Blocking"
            static let navSubtitle = "Block distracting apps and create custom schedules to stay in flow"
            static let noBlocklistsTitle = "🛑 No Blocklists Yet!"
            static let noBlocklistsMessage = "Looks like you haven’t made any blocklists yet. Create one to keep distracting apps out of sight during focus time. Staying on track has never been easier!"
            static let newBlocklistButtonTitle = "New Blocklist"
        }

        // MARK: - Icons / Images
        enum Icons {
            static let waveImage = ImageResource.MainImages.appBlockingListWave
            static let newBlocklistSymbol = "plus.circle"
        }
    }
}
