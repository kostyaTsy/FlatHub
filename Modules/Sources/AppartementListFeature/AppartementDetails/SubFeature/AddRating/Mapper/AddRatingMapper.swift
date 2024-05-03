//
//  AddRatingMapper.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation
import FHRepository

enum AddRatingMapper {
    static func mapToReviewRequestDTO(
        from model: AddRatingModel,
        userId: String,
        appartementRating: Int,
        appartementReviewText: String,
        hostRating: Int,
        hostReviewText: String
    ) -> ReviewRequestDTO {
        ReviewRequestDTO(
            appartementId: model.appartementId,
            appartementReviewText: appartementReviewText,
            appartementRating: appartementRating,
            userIdToReview: model.hostUserId,
            userIdByReview: userId,
            userReviewText: hostReviewText,
            userRating: hostRating
        )
    }
}
