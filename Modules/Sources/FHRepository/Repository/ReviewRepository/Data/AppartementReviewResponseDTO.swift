//
//  AppartementReviewResponseDTO.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

struct AppartementReviewResponseDTO: Codable {
    let id: String
    let userId: String
    let appartementId: String
    let reviewText: String
    let rating: Int
    let createDate: Date

    init(
        id: String = UUID().uuidString,
        userId: String,
        appartementId: String,
        reviewText: String,
        rating: Int,
        createDate: Date = Date.now
    ) {
        self.id = id
        self.userId = userId
        self.appartementId = appartementId
        self.reviewText = reviewText
        self.rating = rating
        self.createDate = createDate
    }
}
