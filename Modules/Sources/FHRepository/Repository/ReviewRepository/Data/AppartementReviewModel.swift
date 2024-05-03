//
//  AppartementReviewModel.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

public struct AppartementReviewModel: Codable {
    public let id: String
    public let user: UserModel
    public let appartementId: String
    public let reviewText: String
    public let rating: Int
    public let createDate: Date

    init(
        id: String = UUID().uuidString,
        user: UserModel,
        appartementId: String,
        reviewText: String,
        rating: Int,
        createDate: Date = Date.now
    ) {
        self.id = id
        self.user = user
        self.appartementId = appartementId
        self.reviewText = reviewText
        self.rating = rating
        self.createDate = createDate
    }
}
