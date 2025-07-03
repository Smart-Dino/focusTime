//
//  GradientBackgroundConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 02.07.25.
//

import SwiftUI

extension FocusSessionView.Constants {
    enum Gradient {
        enum Colors {
            static let backgroundDeep = Color(hex: "#000C10")
            static let gradientTop = Color(hex: "#0E4D76")
            static let gradientBottom = Color(hex: "#9D71FE")
        }
        enum Layout {
            static let gradientOpacity: CGFloat = 0.3
            static let blurRadius: CGFloat = 100
            static let topCircleWidth: CGFloat = 612
            static let topCircleHeight: CGFloat = 394
            static let topCircleOffsetY: CGFloat = -150
            static let bottomCircleWidth: CGFloat = 412
            static let bottomCircleHeight: CGFloat = 323
            static let bottomCircleOffsetY: CGFloat = 170
        }
    }
}
