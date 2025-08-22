//
//  View+Ext.swift
//  FocusTime
//
//  Created by Keto Nioradze on 04.08.25.
//

#if DEBUG
import SwiftUI

// MARK: - Test exstension!!!
// Extension for converting view into image
extension View {
    func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
#endif

