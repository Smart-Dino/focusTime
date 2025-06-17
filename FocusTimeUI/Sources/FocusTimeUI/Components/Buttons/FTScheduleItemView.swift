//
//  FTScheduleItemView.swift
//  FocusTimeUI
//
//  Created by Maksym Horobets on 17.06.2025.
//

import SwiftUI

fileprivate extension ShapeStyle where Self == Color {
    // MARK: AppBlocking Colors
    static var leadingAppBlocking: Color {
        Color("LeadingAppBlockingColor", bundle: .module)
    }
    static var trailingAppBlocking: Color {
        Color("TrailingAppBlockingColor", bundle: .module)
    }
    // MARK: ScheduledFocus Colors
    static var leadingScheduledFocus: Color {
        Color("LeadingScheduledFocusColor", bundle: .module)
    }
    static var trailingScheduledFocus: Color {
        Color("TrailingScheduledFocusColor", bundle: .module)
    }
}

public struct FTScheduleItemView: View {
    public enum Gradients {
        case appBlocking
        case scheduledFocus
        
        var gradient: LinearGradient {
            switch self {
            case .appBlocking:
                LinearGradient(
                    colors: [.leadingAppBlocking, .trailingAppBlocking],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .scheduledFocus:
                LinearGradient(
                    colors: [.leadingScheduledFocus, .trailingScheduledFocus],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
        }
    }
    
    private let emoji: String
    private let title: String
    private let description: String
    private let style: Self.Gradients
    
    public var body: some View {
        HStack(spacing: 15) {
            Text(emoji)
                .font(.title2)
            VStack(alignment: .leading) {
                Text(title)
                Text(description)
                    .foregroundStyle(.ftGray3)
            }
            Spacer()
        }
        .padding()
        .background {
            backgroundShape
                .stroke(style.gradient, lineWidth: 1.2)
        }
    }
    
    var backgroundShape: some Shape {
        UnevenRoundedRectangle(
            cornerRadii: .init(
                topLeading: 25,
                bottomLeading: 0,
                bottomTrailing: 25,
                topTrailing: 0
            )
        )
    }
    
    public init(
        emoji: String,
        title: String,
        description: String,
        style: Self.Gradients
    ) {
        self.emoji = emoji
        self.title = title
        self.description = description
        self.style = style
    }
    
}

#Preview("AppBlocking", traits: .sizeThatFitsLayout) {
    FTScheduleItemView(
        emoji: "💻",
        title: "Work time",
        description: "Weekdays, 8:30 a.m.- 10:30 a.m",
        style: .appBlocking
    )
        .preferredColorScheme(.dark)
}

#Preview("ScheduledFocus", traits: .sizeThatFitsLayout) {
    FTScheduleItemView(
        emoji: "💻",
        title: "Work time",
        description: "Weekdays, 8:30 a.m.- 10:30 a.m",
        style: .scheduledFocus
    )
        .preferredColorScheme(.dark)
}
