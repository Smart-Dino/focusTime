//
//  SplashScreenView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.08.2025.
//

import AVKit
import SwiftUI

struct SplashScreenView: View {
    @State var viewModel: SplashScreenViewModel
    @State private var opacity: Double = .zero
    
    var body: some View {
        ZStack {
            if let player = viewModel.player {
                makeVideoPlayer(with: player)
            } else {
                makeFallbackImage()
            }
            
            Text(Constants.Strings.splashGreeting)
                .font(.largeTitle)
                .fontWeight(.light)
        }
        .opacity(viewModel.state.viewOpacity)
        .onAppear {
            viewModel.startIncreaseOpacityAnimation()
        }
    }
    
    // Makes sense to have it as a computed property,
    // but I wanted to be consistent.
    func makeFallbackImage() -> some View {
        Image(Constants.Icons.fallbackBackground)
            .ignoresSafeArea()
            .scaledToFill()
    }
    
    func makeVideoPlayer(with avPlayer: AVPlayer) -> some View {
        VideoPlayer(player: avPlayer)
            .ignoresSafeArea()
            .scaledToFill()
            .disabled(true)
            .onAppear {
                viewModel.playMedia()
            }
    }
}

#Preview {
    SplashScreenView(viewModel: .init(delegate: nil))
        .preferredColorScheme(.dark)
}
