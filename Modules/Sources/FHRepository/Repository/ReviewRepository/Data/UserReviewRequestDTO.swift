//
//  UserReviewRequestDTO.swift
//  
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

struct UserReviewRequestDTO: Codable {
    let id: String
    let userIdToReview: String
    let userIdByReview: String
    let reviewText: String
    let rating: Int
    let createDate: Date

    init(
        id: String = UUID().uuidString,
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
