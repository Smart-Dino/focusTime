//
//  PromoScreenSecond.swift
//  FocusTime
//
//  Created by Maksym Horobets on 05.08.2025.
//

import SwiftUI
import FocusTimeUI

struct PromoScreenSecond: View {
    var body: some View {
        ZStack {
            Color.ftBackground
                .overlay {
                    Image(.SharedImages.wave)
                        .resizable()
                        .scaledToFill()
                        .rotationEffect(Angle(degrees: -21))
                        .opacity(0.6)
                }
            
            HStack {
                Image(.PaywallImages.promoScreenSecondIcons)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.vertical) { size, _ in
                        size / 1.7
                    }
                
                Rectangle()
                    .foregroundStyle(.ftPaywallPromoGreen)
                    .containerRelativeFrame(.vertical) { size, _ in
                        size / 2.5
                    }
                    .frame(width: 1)
                    .padding(.leading, 50)
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.ftPaywallPromoGreen)
                    .padding()
                
                Text("No more noise.\nJust \(SharedAppValues.appName ?? .init()).")
                    .font(.title.bold())
                    
            }
        }
    }
}

#Preview {
    PromoScreenSecond()
        .preferredColorScheme(.dark)
        .frame(width: 400, height: 400)
}
