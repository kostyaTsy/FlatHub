//
//  HostAppartementDetails.swift
//
//
//  Created by Kostya Tsyvilko on 22.04.24.
//

import Foundation
import FHRepository

public struct HostAppartementDetails {
    public let appartementId: String
    public let latitude: Double
    public let longitude: Double
    public let description: String
    public let bedrooms: Int
    public let beds: Int
    public let bathrooms: Int
    public let type: AppartementType
    public let livingType: AppartementLivingType
    public let offers: [AppartementOfferType]
    public let descriptionTypes: [AppartementDescriptionType]
    public let cancellationPolicy: AppartementCancellationPolicyType

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
