//
//  ExploreAppartementDTO.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation

public struct ExploreAppartementDTO: Codable {
    public let id: String
    public let hostUserId: String
    public let title: String
    public let city: String
    public let country: String
    public let countryCode: String
    public let pricePerNight: Int
    public let guestCount: Int
    public var isFavourite: Bool
    public let rating: Double?
    public let reviewCount: Int
    public let photosStringURL: [String]
    public let createDate: Date

    public init(
        id: String,
        hostUserId: String,
        title: String,
        city: String,
        country: String,
        countryCode: String,
        isAvailableForBook: Bool = true,
        pricePerNight: Int,
        guestCount: Int,
        isFavourite: Bool,
        rating: Double? = nil,
        reviewCount: Int = 0,
        photosStringURL: [String],
        createDate: Date
    ) {
        self.id = id
        self.hostUserId = hostUserId
        self.title = title
        self.city = city
        self.country = country
        self.countryCode = countryCode
        self.pricePerNight = pricePerNight
        self.guestCount = guestCount
        self.isFavourite = isFavourite
        self.rating = rating
        self.reviewCount = reviewCount
        self.photosStringURL = photosStringURL
        self.createDate = createDate
    }
}
