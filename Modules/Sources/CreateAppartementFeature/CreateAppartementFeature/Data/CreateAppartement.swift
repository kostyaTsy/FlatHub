//
//  CreateAppartement.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import Foundation
import FHRepository

final public class CreateAppartement {
    let id: String
    var type: AppartementType?
    var livingType: AppartementLivingType?

    var longitude: Double?
    var latitude: Double?
    var city: String?
    var country: String?
    var countryCode: String?

    var guestsCount: Int = 4
    var bedroomsCount: Int = 1
    var bedsCount: Int = 1
    var bathroomsCount: Int = 1

    var offers: [AppartementOfferType] = []
    var photosData: [PhotoDataModel] = []
    var imageUrls: [URL] = []
    var title: String?
    var description: String?
    var descriptions: [AppartementDescriptionType] = []
    var price: Int?
    var cancellationPolicy: AppartementCancellationPolicyType?

    public init(
        id: String = UUID().uuidString,
        type: AppartementType? = nil,
        livingType: AppartementLivingType? = nil,
        longitude: Double? = nil,
        latitude: Double? = nil,
        city: String? = nil,
        country: String? = nil,
        countryCode: String? = nil,
        guestsCount: Int = 4,
        bedroomsCount: Int = 1,
        bedsCount: Int = 1,
        bathroomsCount: Int = 1,
        offers: [AppartementOfferType] = [],
        photosData: [PhotoDataModel] = [],
        imageUrls: [URL] = [],
        title: String? = nil,
        description: String? = nil,
        descriptions: [AppartementDescriptionType] = [],
        price: Int? = nil,
        cancellationPolicy: AppartementCancellationPolicyType? = nil
    ) {
        self.id = id
        self.type = type
        self.livingType = livingType
        self.longitude = longitude
        self.latitude = latitude
        self.city = city
        self.country = country
        self.countryCode = countryCode
        self.guestsCount = guestsCount
        self.bedroomsCount = bedroomsCount
        self.bedsCount = bedsCount
        self.bathroomsCount = bathroomsCount
        self.offers = offers
        self.photosData = photosData
        self.imageUrls = imageUrls
        self.title = title
        self.description = description
        self.descriptions = descriptions
        self.price = price
        self.cancellationPolicy = cancellationPolicy
    }
}
