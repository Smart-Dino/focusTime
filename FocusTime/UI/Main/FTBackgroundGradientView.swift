//
//  MainBackgroundGradientView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftUI

public struct FTBackgroundGradientView: View {
    public var body: some View {
        ZStack {
            Color.ftBackground
                .ignoresSafeArea()
            VStack {
                Group {
                    Circle()
                        .fill(.ftBackgroundBlueColor.opacity(0.5))
                    Spacer()
                    Circle()
                        .fill(.ftDarkBlue)
                }
            }
        }
        .blur(radius: 160)
    }
}

#Preview {
    FTBackgroundGradientView()
}
