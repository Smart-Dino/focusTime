//
//  PresetIconView.swift
//  FocusTime
//
//  Created by Keto Nioradze on 18.06.25.
//

import SwiftUI

struct PresetIconView: View {
    let preset: FocusPreset
    let isSelected: Bool
    
    private typealias Layout = FocusSessionView.Constants.PresetIcon.Layout
    private typealias Colors = FocusSessionView.Constants.PresetIcon.Colors
    
    var body: some View {
        VStack(spacing: Layout.mainSpacing) {
            ZStack {
                Rectangle()
                    .fill(Colors.background)
                    .frame(width: Layout.size, height: Layout.size)
                    .cornerRadius(Layout.cornerRadius)
                
                if isSelected {
                    Rectangle()
                        .fill(Colors.selectedBackground)
                        .frame(width: Layout.size, height: Layout.size)
                        .cornerRadius(Layout.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                                .stroke(Colors.selectedBorder, lineWidth: Layout.selectedBorderWidth)
                        )
                }
                
                Image(preset.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Layout.size * Layout.iconScaleFactor, height: Layout.size * Layout.iconScaleFactor)
            }
            
            Text(preset.name)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}


#Preview {
    PresetIconView(preset: FocusPreset(name: "Test", iconName: "Study"), isSelected: true)
}
