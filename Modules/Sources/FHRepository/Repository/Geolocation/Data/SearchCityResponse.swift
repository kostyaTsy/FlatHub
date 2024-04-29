//
//  SearchCityResponse.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation

public struct SearchCityResponse: Codable {
    public let city: String
    public let countryCode: String

    init(
        city: String,
        countryCode: String
    ) {
        self.city = city
        self.countryCode = countryCode
    }
}
