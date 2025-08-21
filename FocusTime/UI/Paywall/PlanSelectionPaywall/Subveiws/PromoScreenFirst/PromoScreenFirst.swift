//
//  PlanSelectionFirstPromoView.swift
//  FocusTime
//
//  Created by Maksym Horobets on 06.08.2025.
//

import SwiftUI

struct PlanSelectionFirstPromoView: View {
    var body: some View {
        ZStack {
            Image(PlanSelectionFirstPromoView.Constants.Images.background)
                .resizable()
                .scaledToFit()
            
            VStack {
                Text(PlanSelectionFirstPromoView.Constants.Strings.headline)
                    .foregroundStyle(PlanSelectionFirstPromoView.Constants.Colors.headline)
                Text(PlanSelectionFirstPromoView.Constants.Strings.subtitle)
                    .font(PlanSelectionFirstPromoView.Constants.Fonts.subtitle)
            }
        }
    }
}

#Preview {
    PlanSelectionFirstPromoView()
        .preferredColorScheme(.dark)
}
