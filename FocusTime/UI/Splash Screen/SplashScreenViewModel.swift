//
//  SplashScreenViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.08.2025.
//

import AVKit
import os.log
import SwiftUI

@MainActor
@Observable
final class SplashScreenViewModel {
    struct State {
        var viewOpacity: Double = .zero
        var player: AVPlayer?
    }
    private(set) var state: State
    private let logger: Logger
    @ObservationIgnored var playerNotificationTask: Task<Void, Never>? = nil
    
    private var analyticsManager: AnalyticsManagerProtocol
    
    init(
        state: State = State(),
        videoURL: URL? = Bundle.main.url(forResource: "splash_screen", withExtension: "mp4"),
        logger: Logger = Logger(
            subsystem: Bundle.main.bundleIdentifier ?? .init(),
            category: String(describing: SplashScreenViewModel.self)
        ),
        analyticsManager: AnalyticsManagerProtocol = LiveAnalyticsManager()
    ) {
        self.state = state
        self.logger = logger
        self.analyticsManager = analyticsManager

        if let videoURL {
            self.state.player = AVPlayer(url: videoURL)
            subscribeToPlayer()
        } else {
            self.logger.warning(
                """
                Wasn't able to retrieve media for provided URL. 
                Falling back to static image.
                """
            )
        }
    }
    
    deinit {
        playerNotificationTask?.cancel()
        playerNotificationTask = nil
    }
    
    func subscribeToPlayer() {
        playerNotificationTask = Task.detached { [weak self] in
            let notifications = await NotificationCenter.default.notifications(
                named: .AVPlayerItemDidPlayToEndTime,
                object: self?.state.player?.currentItem
            )
            
            for await _ in notifications {
                await self?.state.player?.seek(to: .zero)
                await self?.state.player?.play()
            }
        }
    }
    
    func playMedia() {
        /// - Analytics
        analyticsManager.logEvent(name: AnalyticsEventsConstants.SplashScreenViewAnalyticsConstants.AnalyticsEvents.splashScreenVideoPlayed.rawValue, parameters: nil)
        
        state.player?.play()
    }
    
    func startIncreaseOpacityAnimation() {
        /// - Analytics
        analyticsManager.logEvent(name: AnalyticsEventsConstants.SplashScreenViewAnalyticsConstants.AnalyticsEvents.splashScreenAnimationStarted.rawValue, parameters: nil)
        
        withAnimation(.easeIn(duration: SharedAppValues.splashScreenDuration)) {
            state.viewOpacity = 1
        }
    }
    
}
