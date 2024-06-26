//
//  AppartementModel.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation

public struct AppartementModel: Identifiable {
    public let id: String
    public let hostUserId: String
    public let title: String
    public let city: String
    public let countryCode: String
    public let pricePerNight: Int
    public let guestCount: Int
    public var isFavourite: Bool
    public let rating: Double?
    public let reviewCount: Int
    public let photos: [String]
    public let createDate: Date

    /// City + CountryCode, format 'City, CountryCode'
    public var location: String {
        "\(city), \(countryCode)"
    }

    public var formattedRating: String {
        guard let rating else { return "" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ""

        let value = NSNumber(value: rating)
        return formatter.string(from: value) ?? ""
    }

    public init(
        id: String,
        hostUserId: String,
        title: String,
        city: String,
        countryCode: String,
        pricePerNight: Int,
        guestCount: Int,
        isFavourite: Bool = false,
        rating: Double? = nil,
        reviewCount: Int = 0,
        photos: [String] = [],
        createDate: Date = Date.now
    ) {
        self.id = id
        self.hostUserId = hostUserId
        self.title = title
        self.city = city
        self.countryCode = countryCode
        self.pricePerNight = pricePerNight
        self.guestCount = guestCount
        self.isFavourite = isFavourite
        self.rating = rating
        self.reviewCount = reviewCount
        self.photos = photos
        self.createDate = createDate
    }
}
