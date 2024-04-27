//
//  AppartementDTO.swift
//
//
//  Created by Kostya Tsyvilko on 22.04.24.
//

import Foundation

public struct AppartementDTO: Codable {
    public let id: String
    public let hostUserId: String
    public let title: String
    public let city: String
    public let country: String
    public let countryCode: String
    public let isAvailableForBook: Bool
    public let pricePerNight: Int
    public let guestCount: Int
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
        self.isAvailableForBook = isAvailableForBook
        self.pricePerNight = pricePerNight
        self.guestCount = guestCount
        self.rating = rating
        self.reviewCount = reviewCount
        self.photosStringURL = photosStringURL
        self.createDate = createDate
    }
}
