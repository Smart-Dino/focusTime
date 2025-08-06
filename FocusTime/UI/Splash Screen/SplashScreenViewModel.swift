//
//  SplashScreenViewModel.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.08.2025.
//

import AVKit
import SwiftUI

@MainActor
@Observable
final class SplashScreenViewModel {
    struct State {
        var viewOpacity: Double = .zero
    }
    private(set) var state: State
    private(set) var player: AVPlayer?
    @ObservationIgnored var playerNotificationTask: Task<Void, Never>? = nil
    
    weak var delegate: SplashScreenDelegate?
    
    init(
        state: State = State(),
        videoURL: URL? = Bundle.main.url(forResource: "splash_screen", withExtension: "mp4"),
        delegate: SplashScreenDelegate?
    ) {
        self.state = state
        self.delegate = delegate
        
        if let videoURL {
            self.player = AVPlayer(url: videoURL)
            subscribeToPlayer()
        } else {
            delegate?.didFinishInitWithError(SplashScreenError.invalidURL)
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
                object: self?.player?.currentItem
            )
            
            for await _ in notifications {
                await self?.player?.seek(to: .zero)
                await self?.player?.play()
            }
        }
    }
    
    func playMedia() {
        player?.play()
    }
    
    func startIncreaseOpacityAnimation() {
        withAnimation(.easeIn(duration: SharedAppValues.splashScreenDuration)) {
            state.viewOpacity = 1
        }
    }
    
}
