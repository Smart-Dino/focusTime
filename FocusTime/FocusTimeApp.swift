//
//  FocusTimeApp.swift
//  FocusTime
//
//  Created by George Kyrylenko on 16.04.2025.
//

import SwiftUI

@main
struct FocusTimeApp: App {
    var body: some Scene {
        WindowGroup {
            // MARK: This will get removed as soon as everyting is tested
            #if(DEBUG)
            StoreKitPaymentManagerDebugView(paymentManager: StoreKitPaymentManager())
            #else
            ContentView()
            #endif
        }
    }
}
