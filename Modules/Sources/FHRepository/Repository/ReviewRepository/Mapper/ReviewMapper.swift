//
//  ReviewMapper.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation
import FirebaseFirestore

enum ReviewMapper {
    static func mapToUserReviewDTO(
        from review: ReviewRequestDTO
    ) -> UserReviewRequestDTO {
        UserReviewRequestDTO(
            userIdToReview: review.userIdToReview,
            userIdByReview: review.userIdByReview,
            reviewText: review.userReviewText,
            rating: review.userRating
        )
    }

    static func mapToAppartementReviewDTO(
        from review: ReviewRequestDTO
    ) -> AppartementReviewRequestDTO {
        AppartementReviewRequestDTO(
            userId: review.userIdByReview,
            appartementId: review.appartementId,
            reviewText: review.appartementReviewText,
            rating: review.appartementRating
        )
    }

    static func mapToUserReviewModel(
        from review: UserReviewResponseDTO,
        userToReview: UserModel,
        userByReview: UserModel
    ) -> UserReviewModel {
        UserReviewModel(
            id: review.id,
            userToReview: userToReview,
            userByReview: userByReview,
            reviewText: review.reviewText,
            rating: review.rating,
            createDate: review.createDate
        )
    }

    static func mapToAppartementReviewModel(
        from review: AppartementReviewResponseDTO,
        user: UserModel
    ) -> AppartementReviewModel {
        AppartementReviewModel(
            id: review.id,
            user: user,
            appartementId: review.appartementId,
            reviewText: review.reviewText,
            rating: review.rating,
            createDate: review.createDate
        )
    }

    static func mapToUpdateAppartementRatingDTO(
        appartementId: String,
        averageRating: Double,
        reviewCount: Int
    ) -> UpdateAppartementRatingDTO {
        UpdateAppartementRatingDTO(
            appartementId: appartementId,
            reviewCount: reviewCount,
            rating: averageRating
        )
    }
}
