//
//  LiveReviewRequestManager.swift
//  FocusTime
//
//  Created by George Kyrylenko on 06.09.2025.
//

import Foundation

class LiveReviewRequestManager: ReviewRequestManager {
    var defaultsManager: DefaultsManager
    
    var isNeedToRequestReview: Bool {
        let lastReviewDate: Date? = defaultsManager.getValue(for: .lastReviewDate)
        let countOfReviews: Int = defaultsManager.getValue(for: .countOfReviews) ?? 0
        
        guard let lastReviewDate else {
            onRequestReview()
            return true
        }
        
        if !lastReviewDate.isToday, countOfReviews <= 5 {
            onRequestReview()
            return true
        } else {
            return false
        }
    }
    
    init(defaultsManager: DefaultsManager = LiveDefaultsManager()) {
        self.defaultsManager = defaultsManager
    }
    
    func onRequestReview() {
        let countOfReviews: Int = defaultsManager.getValue(for: .countOfReviews) ?? 0
        defaultsManager.setValue(for: .lastReviewDate, to: Date())
        defaultsManager.setValue(for: .countOfReviews, to: countOfReviews + 1)
    }
}
