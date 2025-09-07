//
//  AppBlockingListConstants.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import Foundation
import SwiftUI
import Lottie

extension DraftsBlockItemListView {
    enum Constants {
        // MARK: - Typography
        enum Fonts {
            static let navigationTitle = SharedConstants.Fonts.navigationTitle
        }

        // MARK: - Strings
        enum Strings {
            static let navTitle = String(localized: "app_blocking_list_nav_title", table: "MainLocalizable")
            static let navSubtitle = String(localized: "app_blocking_list_nav_subtitle", table: "MainLocalizable")
            static let noBlocklistsTitle = String(localized: "app_blocking_list_no_blocklists_title", table: "MainLocalizable")
            static let noBlocklistsMessage = String(localized: "app_blocking_list_no_blocklists_message", table: "MainLocalizable")
            static let newBlocklistButtonTitle = String(localized: "app_blocking_list_new_blocklist_button_title", table: "MainLocalizable")
        }

        // MARK: - Icons / Images
        enum Icons {
            static let waveImage = ImageResource.MainImages.appBlockingListWave
            static let newBlocklistSymbol = "plus.circle"
        }
        
        enum Layout {
            static let animationScale: CGPoint = .init(x: 1.3, y: 0.9)
            static let animationOpacity: CGFloat = 0.3
        }
        
        enum Animations {
            static let waveAnimation: LottieAnimation? = .filepath(
                Bundle.main.url(forResource: "Wave Animation", withExtension: "json")?.relativePath ?? String()
            )
        }
    }
}

