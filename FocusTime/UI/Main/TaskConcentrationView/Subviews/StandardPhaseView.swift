//
//  StandardPhaseView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 18.08.2025.
//

import SwiftUI

import SwiftUI

struct StandardPhaseView<CenterContent: View, PrimaryButtonContent: View>: View {
    // Constant properties.
    let title: String
    // This is var for a correct memberwise initializer.
    var subtitle: String? = nil
    let backgroundImage: ImageResource
    
    // Closures.
    @ViewBuilder let centerView: () -> CenterContent
    @ViewBuilder let primaryButton: () -> PrimaryButtonContent
    let endSessionAction: () -> Void
    
    var body: some View {
        ZStack {
            // Background image
            VStack {
                Spacer()
                Image(backgroundImage)
                    .resizable()
                    .scaledToFit()
            }
            .ignoresSafeArea()
            
            // Foreground content.
            VStack {
                // Title & Subtitle.
                Group {
                    Text(title)
                        .font(SharedConstants.Fonts.navigationTitle)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .foregroundStyle(.ftGray3Light)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Center view (timer/animation).
                centerView()
                
                Spacer()
                
                // Primary button.
                primaryButton()
                    .buttonStyle(.ftPrimary)
                
                // End session button.
                Button(TaskConcentrationView.Constants.Strings.endSessionButtonTitle, action: endSessionAction)
                    .padding(.vertical)
            }
            .padding(.horizontal)
        }
    }
}
