//
//  PromoScreenFirst.swift
//  FocusTime
//
//  Created by Maksym Horobets on 06.08.2025.
//

import SwiftUI

struct PromoScreenFirst: View {
    var body: some View {
        ZStack {
            Image(.PaywallImages.promoScreenFirstBackground)
                .resizable()
                .scaledToFit()
            
            VStack {
                Text("Choose clarity over chaos")
                    .foregroundStyle(.ftGray3Light)
                Text("Deep Focus with Pro.")
                    .font(.title.bold())
            }
        }
    }
}

#Preview {
    PromoScreenFirst()
        .preferredColorScheme(.dark)
}
