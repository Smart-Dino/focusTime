//
//  SharedAppValues.swift
//  FocusTime
//
//  Created by Maksym Horobets on 27.06.2025.
//

import Foundation

enum SharedAppValues {
    static let appGroupIdentifier = "group.org.dino.smart.FocusTime"
    static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    
    enum DefaultsKeys: String {
        case isOnboardingFinished = "IS_ONBOARDING_FINISHED"
    }
}
