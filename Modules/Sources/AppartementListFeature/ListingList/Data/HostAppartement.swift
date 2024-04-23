//
//  HostAppartement.swift
//
//
//  Created by Kostya Tsyvilko on 22.04.24.
//

import Foundation

public struct HostAppartement: Identifiable {
    public let id: String
    let hostUserId: String
    let title: String
    let city: String
    let country: String
    let countryCode: String
    var isAvailableForBook: Bool
    let pricePerNight: Int
    let guestCount: Int
    let rating: Double?
    let reviewCount: Int
    let photosStringURL: [String]
    let createDate: Date

    let details: HostAppartementDetails

    var location: String {
        "\(city), \(country)"
    }

    public init(
        id: String,
        hostUserId: String,
        title: String,
        city: String,
        country: String,
        countryCode: String,
        isAvailableForBook: Bool,
        pricePerNight: Int,
        guestCount: Int,
        rating: Double? = nil,
        reviewCount: Int = 0,
        photosStringURL: [String],
        createDate: Date = Date.now,
        details: HostAppartementDetails
    ) {
        self.id = id
        self.hostUserId = hostUserId
        self.title = title
        self.city = city
        self.country = country
        self.countryCode = countryCode
        self.isAvailableForBook = isAvailableForBook
        self.pricePerNight = pricePerNight
        self.guestCount = guestCount
        self.rating = rating
        self.reviewCount = reviewCount
        self.photosStringURL = photosStringURL
        self.createDate = createDate
        self.details = details
    }
}
