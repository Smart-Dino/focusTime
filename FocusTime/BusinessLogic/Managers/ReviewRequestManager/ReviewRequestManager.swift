//
//  ReviewRequestManager.swift
//  FocusTime
//
//  Created by George Kyrylenko on 06.09.2025.
//

protocol ReviewRequestManager {
    var isNeedToRequestReview: Bool { get }
}

class ReviewRequestManagerPositiveMock: ReviewRequestManager {
    var isNeedToRequestReview: Bool { return true }
}

class RevokeReviewRequestManagerNegativeMock: ReviewRequestManager {
    var isNeedToRequestReview: Bool { return false }
}
