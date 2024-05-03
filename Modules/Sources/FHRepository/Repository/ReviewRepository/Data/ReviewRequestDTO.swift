//
//  ReviewRequestDTO.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

public struct ReviewRequestDTO {
    let appartementId: String
    let appartementReviewText: String
    let appartementRating: Int

    let userIdToReview: String
    let userIdByReview: String
    let userReviewText: String
    let userRating: Int

    public init(
        appartementId: String,
        appartementReviewText: String,
        appartementRating: Int,
        userIdToReview: String,
        userIdByReview: String,
        userReviewText: String,
        userRating: Int
    ) {
        self.appartementId = appartementId
        self.appartementReviewText = appartementReviewText
        self.appartementRating = appartementRating
        self.userIdToReview = userIdToReview
        self.userIdByReview = userIdByReview
        self.userReviewText = userReviewText
        self.userRating = userRating
    }
}
