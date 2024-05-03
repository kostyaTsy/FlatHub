//
//  UserReviewResponseDTO.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

public struct UserReviewResponseDTO: Codable {
    public let id: String
    public let userIdToReview: String
    public let userIdByReview: String
    public let reviewText: String
    public let rating: Int
    public let createDate: Date

    init(
        id: String,
        userIdToReview: String,
        userIdByReview: String,
        reviewText: String,
        rating: Int,
        createDate: Date = Date.now
    ) {
        self.id = id
        self.userIdToReview = userIdToReview
        self.userIdByReview = userIdByReview
        self.reviewText = reviewText
        self.rating = rating
        self.createDate = createDate
    }
}
