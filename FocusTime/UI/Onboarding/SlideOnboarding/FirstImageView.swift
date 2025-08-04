//
//  FirstImageView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 04.08.25.
//

import SwiftUI
import FocusTimeUI


// MARK: Test view for the first image modification layers
struct FirstImageView: View {
    
    var body: some View {
        VStack(alignment: .center, ) {
            ZStack(alignment: .center) {
                Image("WaveCycles")
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 430)
                
                Ellipse()
                    .fill(Color.ftOnboardingImageOverlayColor.opacity(0.5))
                    .rotationEffect(.degrees(90))
                    .blur(radius: 30, opaque: false)
                    .frame(width: 197, height: 270)
                
                VStack {
                    Image("Timer")
                    
                    Text("Focus time")
                }
                
            }
        }
        .ignoresSafeArea()
        .background(.ftBackground)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    FirstImageView()
}
