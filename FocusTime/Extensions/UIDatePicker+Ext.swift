//
//  UIDatePicker+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 26.08.2025.
//

import UIKit

extension UIDatePicker {
    open override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: super.intrinsicContentSize.height
        )
    }
}
