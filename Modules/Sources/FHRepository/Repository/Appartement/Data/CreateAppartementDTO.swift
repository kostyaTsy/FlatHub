//
//  CreateAppartementDTO.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

public struct CreateAppartementDTO {
    let id: String
    let hostUserId: String

    let title: String
    let description: String
    let city: String
    let county: String
    let countryCode: String

    let pricePerNight: Int
    let guestsCount: Int
    let photosStringURL: [String]

    let longitude: Double
    let latitude: Double

    let bedrooms: Int
    let bathrooms: Int
    let beds: Int

    let createDate: Date

    let type: AppartementType
    let livingType: AppartementLivingType
    let offers: [AppartementOfferType]
    let descriptionTypes: [AppartementDescriptionType]
    let cancellationPolicy: AppartementCancellationPolicyType

    public init(
        id: String = UUID().uuidString,
        hostUserId: String,
        title: String,
        description: String,
        city: String,
        county: String,
        countryCode: String,
        pricePerNight: Int,
        guestsCount: Int,
        photosStringURL: [String],
        longitude: Double,
        latitude: Double,
        bedrooms: Int,
        bathrooms: Int,
        beds: Int,
        createDate: Date = Date.now,
        type: AppartementType,
        livingType: AppartementLivingType,
        offers: [AppartementOfferType],
        descriptionTypes: [AppartementDescriptionType],
        cancellationPolicy: AppartementCancellationPolicyType
    ) {
        self.id = id
        self.hostUserId = hostUserId
        self.title = title
        self.description = description
        self.city = city
        self.county = county
        self.countryCode = countryCode
        self.pricePerNight = pricePerNight
        self.guestsCount = guestsCount
        self.photosStringURL = photosStringURL
        self.longitude = longitude
        self.latitude = latitude
        self.bedrooms = bedrooms
        self.bathrooms = bathrooms
        self.beds = beds
        self.createDate = createDate
        self.type = type
        self.livingType = livingType
        self.offers = offers
        self.descriptionTypes = descriptionTypes
        self.cancellationPolicy = cancellationPolicy
    }
}
