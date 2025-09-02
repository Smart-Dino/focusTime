//
//  SharedAppValues.swift
//  FocusTime
//
//  Created by Maksym Horobets on 27.06.2025.
//

import Foundation
import ManagedSettings

enum SharedAppValues {
    static let appGroupIdentifier = "group.org.dino.smart.FocusTime"
    static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    static let appIdentifier = Bundle.main.bundleIdentifier ?? "No bundle name"
    
    static let splashScreenDuration: TimeInterval = 2
    #if DEBUG
    static let breakTimeDuration: Int = 60 // 1 minute.
    #else
    static let breakTimeDuration: Int = 300 // 5 minutes.
    #endif
    static let debounceAfterDBRefreshed: Duration = .seconds(0.3)
    
    /// A small "leeway" tolerance (100ms) used when scheduling sleeps or timers.
    /// This tells the system it can wake slightly later than the exact deadline,
    /// which reduces CPU wakeups and improves power efficiency without noticeably
    /// affecting accuracy for 1-second intervals.
    static let timerLeeway: Duration = .milliseconds(100)
    
    static let activityRegistrarFallbackInterval: Int = 15 * 60
    
    static let amountOfItemsPerPage: Int = 100
    
    @MainActor
    enum FreeUserLimits {
        static let maximumAmountOfBlocks = 1
        static let defaultCategorieSelection: ShieldSettings.ActivityCategoryPolicy<Application> = .all()
    }
    
    enum DefaultsKeys: String {
        case isOnboardingFinished = "IS_ONBOARDING_FINISHED"
    }
}
