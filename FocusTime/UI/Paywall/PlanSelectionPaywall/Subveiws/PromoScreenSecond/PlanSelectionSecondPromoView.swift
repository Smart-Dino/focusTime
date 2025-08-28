//
//  PlanSelectionSecondPromoView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.08.2025.
//

import SwiftUI
import FocusTimeUI

struct PlanSelectionSecondPromoView: View {
    var body: some View {
        ZStack {
            Constants.Colors.background
                .overlay {
                    Image(Constants.Images.background)
                        .resizable()
                        .scaledToFill()
                        .rotationEffect(Angle(degrees: -21))
                        .opacity(0.6)
                }
            
            HStack {
                Image(Constants.Images.icons)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.vertical) { size, _ in
                        size / 1.7
                    }
                
                Rectangle()
                    .foregroundStyle(Constants.Colors.accent)
                    .containerRelativeFrame(.vertical) { size, _ in
                        size / 2.5
                    }
                    .frame(width: 1)
                    .padding(.leading, 50)
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Constants.Colors.accent)
                    .padding()
                
                Text(Constants.Strings.subtitle)
                    .font(Constants.Fonts.headline)
                    
            }
        }
    }
}

#Preview {
    PlanSelectionSecondPromoView()
        .preferredColorScheme(.dark)
        .frame(width: 400, height: 400)
}
