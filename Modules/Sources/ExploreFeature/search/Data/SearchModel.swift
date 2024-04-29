//
//  SearchModel.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation

public struct SearchModel {
    let city: String
    let countryCode: String?

    let startDate: Date
    let endDate: Date

    let guestsCount: Int

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
