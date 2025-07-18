//
//  ShieldConfigurationExtension.swift
//  FocusTimeShieldConfiguration
//
//  Created by Maksym Horobets on 17.07.2025.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    let shieldDesigns: [ShieldConfiguration] = [
        ShieldUIRepo.whaleShield,
        ShieldUIRepo.surferShield,
        ShieldUIRepo.waveIconShield
    ]

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        shieldDesigns.randomElement()!
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        shieldDesigns.randomElement()!
    }
}
