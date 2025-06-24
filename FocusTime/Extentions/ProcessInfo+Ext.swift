//
//  ProcessInfo+Ext.swift
//  StorifyQR
//
//  Created by Maks Winters on 10.02.2024.
//
// https://stackoverflow.com/questions/58759987/how-do-you-check-if-swiftui-is-in-preview-mode
//

import Foundation

extension ProcessInfo {
   static func isOnPreview() -> Bool {
       return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
   }
}
