//
//  UserReviewModel.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

public struct UserReviewModel: Codable {
    public let id: String
    public let userToReview: UserModel
    public let userByReview: UserModel
    public let reviewText: String
    public let rating: Int
    public let createDate: Date

    init(
        id: String,
        userToReview: UserModel,
        userByReview: UserModel,
        reviewText: String,
        rating: Int,
        createDate: Date = Date.now
    ) {
        self.id = id
        self.userToReview = userToReview
        self.userByReview = userByReview
        self.reviewText = reviewText
        self.rating = rating
        self.createDate = createDate
    }
}

