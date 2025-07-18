//
//  ShieldUIRepo.swift
//  FocusTimeShieldConfiguration
//
//  Created by Maksym Horobets on 18.07.2025.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

struct ShieldUIRepo {
    static let whaleShield = ShieldConfiguration(
        backgroundBlurStyle: .dark,
        backgroundColor: .darkBackground,
        icon: .whale,
        title: .init(text: "You’re in the zone.", color: .white),
        subtitle: .init(
            text: "You’ve already set sail into focus waters. This app can wait. Your goals can't.",
            color: .secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark))
        ),
        primaryButtonLabel: .init(text: "Ignore the noise", color: .white),
        primaryButtonBackgroundColor: .mainBlue,
    )
    
    static let waveIconShield = ShieldConfiguration(
        backgroundBlurStyle: .dark,
        backgroundColor: .darkBackground,
        icon: .waveIcon,
        title: .init(text: "Interrupting the tide?", color: .white),
        subtitle: .init(
            text: "This app is off-limits during your DeepWave session. Take a breath, ride it through — the wave will carry you further.",
            color: .secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark))
        ),
        primaryButtonLabel: .init(text: "Stay in flow", color: .white),
        primaryButtonBackgroundColor: .mainBlue,
    )
    
    static let surferShield = ShieldConfiguration(
        backgroundBlurStyle: .dark,
        backgroundColor: .darkBackground,
        icon: .waveSurfer,
        title: .init(text: "You're drifting off course...", color: .white),
        subtitle: .init(
            text: "This app isn’t part of your current focus. Stay in the deep, ride the wave — and let productivity flow.",
            color: .secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark))
        ),
        primaryButtonLabel: .init(text: "Back to the flow", color: .white),
        primaryButtonBackgroundColor: .mainBlue,
    )
    
    private init () { }
}
