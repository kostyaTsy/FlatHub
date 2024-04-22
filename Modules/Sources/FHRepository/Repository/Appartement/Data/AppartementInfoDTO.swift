//
//  AppartementInfoDTO.swift
//
//
//  Created by Kostya Tsyvilko on 22.04.24.
//

import Foundation

public struct AppartementInfoDTO: Codable {
    let appartementId: String
    let latitude: Double
    let longitude: Double
    let description: String
    let bedrooms: Int
    let beds: Int
    let bathrooms: Int
    let type: AppartementType
    let livingType: AppartementLivingType
    let offers: [AppartementOfferType]
    let descriptionTypes: [AppartementDescriptionType]
    let cancellationPolicy: AppartementCancellationPolicyType

    public init(
        appartementId: String,
        latitude: Double,
        longitude: Double,
        description: String,
        bedrooms: Int,
        beds: Int,
        bathrooms: Int,
        type: AppartementType,
        livingType: AppartementLivingType,
        offers: [AppartementOfferType],
        descriptionTypes: [AppartementDescriptionType],
        cancellationPolicy: AppartementCancellationPolicyType
    ) {
        self.appartementId = appartementId
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.bedrooms = bedrooms
        self.beds = beds
        self.bathrooms = bathrooms
        self.type = type
        self.livingType = livingType
        self.offers = offers
        self.descriptionTypes = descriptionTypes
        self.cancellationPolicy = cancellationPolicy
    }
}
