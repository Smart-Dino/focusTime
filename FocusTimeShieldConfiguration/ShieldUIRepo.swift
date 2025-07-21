//
//  ShieldUIRepo.swift
//  FocusTimeShieldConfiguration
//
//  Created by Maksym Horobets on 18.07.2025.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// The properties of this enum are computed because ShieldConfiguration is not sendable
// to be stored and then sent to anywhere.
enum ShieldUIRepo {
    static var whaleShield: ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .dark,
            backgroundColor: .darkBackground,
            icon: .whale,
            title: .init(text: String(localized: "shield_whale_title"), color: .white),
            subtitle: .init(
                text: String(localized: "shield_whale_subtitle"),
                color: .secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark))
            ),
            primaryButtonLabel: .init(text: String(localized: "shield_whale_button"), color: .white),
            primaryButtonBackgroundColor: .mainBlue,
        )
    }
    
    static var waveIconShield: ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .dark,
            backgroundColor: .darkBackground,
            icon: .waveIcon,
            title: .init(text: String(localized: "shield_wave_title"), color: .white),
            subtitle: .init(
                text: String(localized: "shield_wave_subtitle"),
                color: .secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark))
            ),
            primaryButtonLabel: .init(text: String(localized: "shield_wave_button"), color: .white),
            primaryButtonBackgroundColor: .mainBlue,
        )
    }
    
    static var surferShield: ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .dark,
            backgroundColor: .darkBackground,
            icon: .waveSurfer,
            title: .init(text: String(localized: "shield_surfer_title"), color: .white),
            subtitle: .init(
                text: String(localized: "shield_surfer_subtitle"),
                color: .secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark))
            ),
            primaryButtonLabel: .init(text: String(localized: "shield_surfer_button"), color: .white),
            primaryButtonBackgroundColor: .mainBlue,
        )
    }
}

