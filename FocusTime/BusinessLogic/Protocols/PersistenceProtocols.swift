//
//  PersistenceProtocols.swift
//  FocusTime
//
//  Created by Keto Nioradze on 16.06.25.
//

import Foundation

@MainActor
/// The -ing suffix is a common Swift convention for protocols.
protocol OnboardingPersistenceManaging {
    var onboardingProgress: OnboardingProgress { get set }
}
