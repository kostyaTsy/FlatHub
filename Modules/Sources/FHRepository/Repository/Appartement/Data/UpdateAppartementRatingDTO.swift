//
//  UpdateAppartementRatingDTO.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

public struct UpdateAppartementRatingDTO {
    let appartementId: String
    let reviewCount: Int
    let rating: Double

    public init(
        appartementId: String,
        reviewCount: Int,
        rating: Double
    ) {
        self.appartementId = appartementId
        self.reviewCount = reviewCount
        self.rating = rating
    }
}
