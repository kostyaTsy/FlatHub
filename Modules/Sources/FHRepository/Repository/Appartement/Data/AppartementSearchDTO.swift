//
//  AppartementSearchDTO.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation

public struct AppartementSearchDTO {
    public let city: String
    public let countryCode: String?

    public let startDate: Date
    public let endDate: Date

    public let guestsCount: Int

    public init(
        city: String,
        countryCode: String?,
        startDate: Date,
        endDate: Date,
        guestsCount: Int
    ) {
        self.city = city
        self.countryCode = countryCode
        self.startDate = startDate
        self.endDate = endDate
        self.guestsCount = guestsCount
    }
}
