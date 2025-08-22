//
//  CongratulatoryTransitionView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 18.08.2025.
//

import SwiftUI
import Lottie

struct CongratulatoryTransitionView: View {
    let title: String
    let subtitle: String
    let onFinished: () -> Void

    var body: some View {
        VStack {
            LottieView(animation: TaskConcentrationView.Constants.Animations.confettiAnimation)
            .playbackMode(
                .playing(
                    .fromProgress(0,
                                  toProgress: 1,
                                  loopMode: .playOnce)
                )
            )
            .animationDidFinish { _ in
                onFinished()
            }
            .containerRelativeFrame([.vertical]) { size, _ in
                size / 3
            }

            Text(title)
                .font(.title3.bold())

            Text(subtitle)
                .foregroundStyle(.ftGray3Light)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}


#Preview {
    CongratulatoryTransitionView(
        title: "Keep testing!",
        subtitle: "You are on preview!",
        onFinished: {}
    )
    .preferredColorScheme(.dark)
}
